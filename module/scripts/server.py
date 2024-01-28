#!/usr/bin/env python3
import json
import requests
from const import IP_TERMINAL, IP_NETWORK, IP_SERVER
from utils import ping, execute_command, update_and_write_json
import threading

from flask import Flask, jsonify, request
from flask_socketio import SocketIO, join_room, leave_room
from flask_cors import CORS

app = Flask(__name__)
sio = SocketIO(app, cors_allowed_origins="*")
CORS(app)

CONFIG_PATH = "/home/network/demoj/module/config/config.json"
SERVER_PORT = 5000

RESTART_CMD = ["sudo", "reboot"]
STOP_CMD = ["sudo", "shutdown", "-h", "now"]

# ! DEPRECATED
def geHttpAddress(ip):
    return ("http://{}:{}".format(ip, SERVER_PORT))

#################################################################
# DémoJ Connect
#################################################################

@app.route("/")
def index():
    return jsonify({"message": "Server is running"})

@app.route("/receive_data", methods=["POST"])
def receive_data():
    data = request.get_json()
    print("Received data:", data)

    return jsonify({"message": "Data received successfully"})

@app.route("/restart/<module>", methods=["GET"])
def restart_module(module):
    if module == "terminal":
        return jsonify(requests.get(geHttpAddress(IP_TERMINAL) + "/restart").status_code == 200)
    elif module == "server":
        return jsonify(requests.get(geHttpAddress(IP_SERVER) + "/restart").status_code == 200)
    elif module == "network":
        return jsonify(execute_command(RESTART_CMD));
    else:
        return jsonify({"error": "Invalid module"}), 400

@app.route("/stop/<module>", methods=["GET"])
def stop_module(module):
    if module == "terminal":
        return jsonify(requests.get(geHttpAddress(IP_TERMINAL) + "/stop").status_code == 200)
    elif module == "server":
        return jsonify(requests.get(geHttpAddress(IP_SERVER) + "/stop").status_code == 200)
    elif module == "network":
        return jsonify(execute_command(STOP_CMD));
    else:
        return jsonify({"error": "Invalid module"}), 400

@app.route("/config", methods=["GET"])
def get_config():
    try:
        with open(CONFIG_PATH, "r") as config_file:
            config_data = json.load(config_file)
            return jsonify(config_data)
    except FileNotFoundError:
        return jsonify({"error": "Config file not found"}), 404
    except Exception as e:
        print(f"Error reading config file: {str(e)}")
        return jsonify({"error": str(e)}), 500

# TODO Update this method to use update_and_write_json from utils.py
@app.route("/modules/<module>/params/<id_param>", methods=["POST"])
def update_parameter(module, id_param):
    try:
        data = request.get_json()
        is_active = data.get("isActive")
        value = data.get("value")

        with open(CONFIG_PATH, "r+") as config_file:
            config_data = json.load(config_file)

        if "modules" in config_data and module in config_data["modules"]:
            device = config_data["modules"][module]
            if "parameters" in device:
                for param in device["parameters"]:
                    if int(param["id"]) == int(id_param):
                        if is_active is not None:
                            param["isActive"] = is_active
                        if value is not None:
                            param["value"] = value
                        # TODO : toggle parameter on module

        with open(CONFIG_PATH, "w") as config_file:
            json.dump(config_data, config_file, indent=2)

        return jsonify({"message": "Parameter toggled successfully"})
    except Exception as e:
        print(f"Error toggling parameter: {str(e)}")
        return jsonify({"error": str(e)}), 500
    
@app.route("/ping/<module>", methods=["GET"])
def ping_module(module):
    if module == "terminal":
        return jsonify(ping(IP_TERMINAL))
    elif module == "server":
        return jsonify(ping(IP_SERVER))
    elif module == "all":
        return jsonify(ping(IP_TERMINAL) and ping(IP_SERVER))
    else:
        return jsonify({"error": "Invalid module"}), 400
    
@app.route("/check_status/<module>", methods=["GET"])
def check_status(module):
    try:
        if module == "terminal":
            return jsonify(requests.get(geHttpAddress(IP_TERMINAL)).status_code == 200)
        elif module == "server":
            return jsonify(requests.get(geHttpAddress(IP_SERVER)).status_code == 200)
        elif module == "network":
            return jsonify(True)
        else:
            return jsonify({"error": "Invalid module"}), 400
    except Exception as e:
        return jsonify(False), 200
    
#################################################################
# Scenarios
#################################################################
    
# TODO
    
#################################################################
# Socket
#################################################################

@sio.on("connect")
def handle_connect():
    print("Client connected")
    print("ip: ", request.remote_addr)

@sio.on("disconnect")
def handle_disconnect():
    print("Client disconnected")

    device = get_device_from_addr(request.remote_addr)
    
    # Send notfication to client if both terminal and server are ready
    sio.emit("module_off", {"device": device}, room="client")

@sio.on("ready")
def handle_ready(data):
    data = data["device"]
    if data != "terminal" and data != "server" and data != "client":
        print("Invalid module:", data)
        return
    
    print("Device ready:", data)
    join_room(data)
    print("Successfully joined room:", data)

    if data != "client":
        # Update config if terminal or server is ready
        update_and_write_json(CONFIG_PATH, f"modules.{data}.isConnected", True)

        # Send notfication to client if both terminal and server are ready
        sio.emit("module_on", {"device": data}, room="client")

def get_device_from_addr(addr):
    if addr == IP_TERMINAL:
        return "terminal"
    elif addr == IP_SERVER:
        return "server"
    else:
        return "client"
    
#################################################################
# Main
#################################################################

if __name__ == "__main__":
    print("Restoring default config...")
    update_and_write_json(CONFIG_PATH, "modules.terminal.isConnected", False)
    update_and_write_json(CONFIG_PATH, "modules.server.isConnected", False)
    update_and_write_json(CONFIG_PATH, "modules.network.isConnected", True)

    print("Starting server...")
    sio.run(app, debug=True, host="0.0.0.0", port=5000, allow_unsafe_werkzeug=True)