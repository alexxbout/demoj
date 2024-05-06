import json
from const import IP_TERMINAL, IP_NETWORK, IP_SERVER, RESTART_CMD, STOP_CMD, STRESS_CMD
from utils import execute_command, update_and_write_json, get_device_from_addr

from flask import Flask, jsonify, request, render_template, redirect, url_for, send_from_directory
from flask_socketio import SocketIO, join_room, leave_room
from flask_cors import CORS

CONFIG_PATH = "/home/network/demoj/module/config/config.json"
SERVER_PORT = 5000

devices = {
    "terminal": IP_TERMINAL,
    "server": IP_SERVER,
    "network": IP_NETWORK
}

app = Flask(__name__, static_folder="dist/static", template_folder="dist", static_url_path="/static")
sio = SocketIO(app, cors_allowed_origins="*")
CORS(app)

#################################################################
# * DémoJ Connect API Routes
#################################################################

@app.route("/", defaults={"path": ""})
@app.route("/<path:path>")
def index(path):
    return render_template("index.html")

@app.route("/assets/<path:filename>")
def serve_assets(filename):
    return send_from_directory("dist/assets", filename)

#################################################################
# API
#################################################################

@app.route("/api")
def api():
    return jsonify({"message": "DémoJ Connect API is running"})

@app.route("/api/modules/<module>/params/<id_param>", methods=["POST"])
def update_parameter(module, id_param):
    try:
        data = request.get_json()
        is_active = data.get("isActive")
        value = data.get("value")

        if is_active is not None:
            update_and_write_json(CONFIG_PATH, f"modules.{module}.parameters.{id_param}.isActive", is_active)
        if value is not None:
            update_and_write_json(CONFIG_PATH, f"modules.{module}.parameters.{id_param}.value", value)

        return jsonify({"message": "Parameter updated successfully"})
    except Exception as e:
        print(f"Error updating parameter: {str(e)}")
        return jsonify({"error": str(e)}), 500
    
@app.route("/api/config", methods=["GET"])
def get_config():
    try:
        with open(CONFIG_PATH, "r") as f:
            config = json.load(f)
            return jsonify(config)
    except Exception as e:
        print(f"Error getting config: {str(e)}")
        return jsonify({"error": str(e)}), 500
    
#################################################################
# Socket
# ! Be careful to the frequency of the emits
#################################################################

@sio.event
def connect():
    """
    Event handler triggered when a client connects to the server.

    This event adds the new host to its corresponding room in order to broadcast messages to specific hosts.
    """
    device = get_device_from_addr(request.remote_addr)
    print(f"Client connected: {device}")
    
    join_room(device)

    if device != "client":
        # Update connection status of the module in the config file
        update_and_write_json(CONFIG_PATH, f"modules.{device}.isConnected", True)
        # Tell clients that the module is connected
        sio.emit("module_status", {"device": device, "status": "on"}, room="client")

@sio.event
def disconnect():
    """
    Event handler triggered when a client disconnects from the server.
    """
    device = get_device_from_addr(request.remote_addr)
    print("Client disconnected: {device}")

    leave_room(device)

    if device != "client":
        # Update connection status of the module in the config file
        update_and_write_json(CONFIG_PATH, f"modules.{device}.isConnected", False)
        # Tell clients that the module is disconnected
        sio.emit("module_status", {"device": device, "status": "off"}, room="client")

@sio.event
def action(data):
    """
    Event handler triggered when updating the connection status of a module.
    data: { "device": "module", "action": "stop" | "restart" }
    """
    device = data["device"]
    action = data["action"]

    if device == "terminal" or device == "server" or device == "network":
        # Update connection status of the module in the config file
        update_and_write_json(CONFIG_PATH, f"modules.{device}.isConnected", False)

        if device != "network":
            # Forward the action to the corresponding module
            sio.emit(action, room=device)
        else:
            # Execute the action on the network module
            if action == "restart":
                execute_command(RESTART_CMD)
            else:
                execute_command(STOP_CMD)
    
@sio.event
def stress(data):
    """
    Event handler triggered when a stress command is sent to a module.
    data: { "device": "module", "time": 10 }
    """
    device = data["device"]
    time = data["time"]

    if device == "client":
        msg = "Invalid module: {}".format(device)
        return jsonify({"error": msg})
    
    cmd = STRESS_CMD    

    if device != "network":
        sio.emit("stress", { time: time }, room=device)
    else:
        cmd[-1] = str(time)
        execute_command(cmd)

@sio.event
def terminal_calculation(value):
    """
    Event handler triggered when calculation mode is activated on the terminal module.
    value: true | false
    """
    update_and_write_json(CONFIG_PATH, "isBackendCalculator", value)

    sio.emit("calculation", value, room="terminal")

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

    # TODO: See for production deployment here: https://flask.palletsprojects.com/en/2.3.x/deploying/gunicorn/