#!/usr/bin/env python3

from const import IP_TERMINAL, IP_NETWORK, IP_SERVER
from utils import ping, execute_command

from flask import Flask, jsonify, request
from flask_cors import CORS

import json
import requests

app = Flask(__name__)
CORS(app)

CONFIG_PATH = "/home/network/demoj/module/config/config.json"

RESTART_CMD = ['sudo', 'reboot']
STOP_CMD = ['sudo', 'shutdown', '-h', 'now']

def geHttpAddress(ip):
    return 'http://' + ip + ':5000'

@app.route('/')
def index():
    return jsonify({"message": "Server is running"})

#################################################################
# DémoJ Connect routes
#################################################################
@app.route('/receive_data', methods=['POST'])
def receive_data():
    data = request.get_json()
    print("Received data:", data)

    return jsonify({"message": "Data received successfully"})

@app.route('/restart/<module>', methods=['GET'])
def restart_module(module):
    if module == 'terminal':
        return jsonify(requests.get(geHttpAddress(IP_TERMINAL) + '/restart').status_code == 200)
    elif module == 'server':
        return jsonify(requests.get(geHttpAddress(IP_SERVER) + '/restart').status_code == 200)
    elif module == 'network':
        return jsonify(execute_command(RESTART_CMD));
    else:
        return jsonify({"error": "Invalid module"}), 400

@app.route('/stop/<module>', methods=['GET'])
def stop_module(module):
    if module == 'terminal':
        return jsonify(requests.get(geHttpAddress + '/stop').status_code == 200)
    elif module == 'server':
        return jsonify(requests.get(geHttpAddress(IP_SERVER) + '/stop').status_code == 200)
    elif module == 'network':
        return jsonify(execute_command(STOP_CMD));
    else:
        return jsonify({"error": "Invalid module"}), 400

@app.route('/config', methods=['GET'])
def get_config():
    try:
        with open(CONFIG_PATH, 'r') as config_file:
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

        with open(CONFIG_PATH, 'r+') as config_file:
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

        with open(CONFIG_PATH, 'w') as config_file:
            json.dump(config_data, config_file, indent=2)

        return jsonify({"message": "Parameter toggled successfully"})
    except Exception as e:
        print(f"Error toggling parameter: {str(e)}")
        return jsonify({"error": str(e)}), 500
    
@app.route('/ping/<module>', methods=['GET'])
def ping_module(module):
    if module == 'terminal':
        return jsonify(ping(IP_TERMINAL))
    elif module == 'server':
        return jsonify(ping(IP_SERVER))
    elif module == 'all':
        return jsonify(ping(IP_TERMINAL) and ping(IP_SERVER))
    else:
        return jsonify({"error": "Invalid module"}), 400
    
@app.route('/check_status/<module>', methods=['GET'])
def check_status(module):
    try:
        if module == 'terminal':
            return jsonify(requests.get(geHttpAddress(IP_TERMINAL)).status_code == 200)
        elif module == 'server':
            return jsonify(requests.get(geHttpAddress(IP_SERVER)).status_code == 200)
        elif module == 'network':
            return jsonify(True)
        else:
            return jsonify({"error": "Invalid module"}), 400
    except Exception as e:
        return jsonify(False), 200
    
#################################################################
# Scenarios routes
#################################################################

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
