#!/usr/bin/env python3

from const import IP_TERMINAL, IP_NETWORK, IP_SERVER
from module.scripts.utils import ping, execute_command

from flask import Flask, jsonify, request
from flask_cors import CORS

import json
import subprocess

app = Flask(__name__)
CORS(app)

CONFIG_PATH = "/home/network/demoj/module/config/config.json"

RESTART_CMD = ['sudo', 'reboot']
STOP_CMD = ['sudo', 'shutdown', '-h', 'now']

@app.route('/')
def index():
    return jsonify({"message": "Server is running"})

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)