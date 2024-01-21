#!/usr/bin/env python3

from testing import ping
from flask import Flask, jsonify, request
from flask_cors import CORS
import json
import os
import subprocess

app = Flask(__name__)
CORS(app)

path = "/home/network/demoj/network"
config = path + "/config.json"

ip_terminal = "192.168.64.100"
ip_network = "192.168.64.101"
ip_server = "192.168.64.102"

@app.route('/')
def index():
    return jsonify({"message": "Server is running"})

@app.route('/receive_data', methods=['POST'])
def receive_data():
    data = request.get_json()
    print("Received data:", data)

    return jsonify({"message": "Data received successfully"})

@app.route('/restart', methods=['GET'])
def restart_module():
    try:
        subprocess.Popen(['sudo', 'reboot'])
        # TODO Restart other modules using HTTP requests or SSH
        return jsonify({"message": "Successfully restarted Raspberry Pi"})
    except Exception as e:
        print(f"Error restarting Raspberry Pi: {str(e)}")
        return jsonify({"error": str(e)}), 500
    
@app.route('/stop', methods=['GET'])
def stop_module():
    try:
        subprocess.Popen(['sudo', 'shutdown', '-h', 'now'])
        # TODO Stop other modules using HTTP requests or SSH
        return jsonify({"message": "Successfully stopped Raspberry Pi"})
    except Exception as e:
        print(f"Error stopping Raspberry Pi: {str(e)}")
        return jsonify({"error": str(e)}), 500

@app.route('/config', methods=['GET'])
def get_config():
    try:
        with open(config, 'r') as config_file:
            config_data = json.load(config_file)
            return jsonify(config_data)
    except FileNotFoundError:
        return jsonify({"error": "Config file not found"}), 404
    except Exception as e:
        print(f"Error reading config file: {str(e)}")
        return jsonify({"error": str(e)}), 500

@app.route('/modules/<module>/params/<id_param>', methods=['POST'])
def update_parameter(module, id_param):
    try:
        data = request.get_json()
        is_active = data.get('isActive')
        value = data.get('value')

        with open(config, 'r+') as config_file:
            config_data = json.load(config_file)

        if 'modules' in config_data and module in config_data['modules']:
            device = config_data['modules'][module]
            if 'parameters' in device:
                for param in device['parameters']:
                    if int(param['id']) == int(id_param):
                        if is_active is not None:
                            param['isActive'] = is_active
                        if value is not None:
                            param['value'] = value
                        # TODO : toggle parameter on module

        with open(config, 'w') as config_file:
            json.dump(config_data, config_file, indent=2)

        return jsonify({"message": "Parameter toggled successfully"})
    except Exception as e:
        print(f"Error toggling parameter: {str(e)}")
        return jsonify({"error": str(e)}), 500
    
@app.route('/ping/<module>', methods=['GET'])
def ping_module(module):
    if module == 'terminal':
        return jsonify(ping(ip_terminal))
    elif module == 'server':
        return jsonify(ping(ip_server))
    elif module == 'all':
        return jsonify(ping(ip_terminal) and ping(ip_server))
    else:
        return jsonify({"error": "Invalid module"}), 400

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
