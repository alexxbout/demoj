#!/usr/bin/env python3

from const import IP_TERMINAL, IP_NETWORK, IP_SERVER
from utils import ping, execute_command

from flask import Flask, jsonify, request
from flask_cors import CORS

import json
import subprocess

app = Flask(__name__)
CORS(app)

RESTART_CMD = ['sudo', 'reboot']
STOP_CMD = ['sudo', 'shutdown', '-h', 'now']

@app.route('/')
def index():
    return jsonify({"message": "Server is running"})

#################################################################
# DémoJ Connect routes
#################################################################

@app.route('/restart', methods=['GET'])
def restart_module():
    return jsonify(execute_command(RESTART_CMD))

@app.route('/stop', methods=['GET'])
def stop_module():
    return jsonify(execute_command(STOP_CMD))

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)