from const import IP_TERMINAL, IP_NETWORK, IP_SERVER

from flask import Flask, jsonify, request, render_template, redirect, url_for
from flask_cors import CORS

devices = {
    "terminal": IP_TERMINAL,
    "server": IP_SERVER,
    "network": IP_NETWORK
}

APP_FOLDER = "../app"

app = Flask(__name__, template_folder=APP_FOLDER, static_folder=APP_FOLDER, static_url_path="/app/")
CORS(app)

SERVER_PORT = 5000

RESTART_CMD = ["sudo", "reboot"]
STOP_CMD = ["sudo", "shutdown", "-h", "now"]

STRESS_LVL_1_CMD = ["stress", "-c", "1", "-i", "1", "-m", "1", "--timeout", "10s"]
STRESS_LVL_2_CMD = ["stress", "-c", "2", "-i", "2", "-m", "2", "--timeout", "10s"]
STRESS_LVL_3_CMD = ["stress", "-c", "4", "-i", "4", "-m", "4", "--timeout", "10s"]

#################################################################
# API
#################################################################

@app.route("/api")
def api():
    return jsonify({"message": "Server API is running"})
    
#################################################################
# Scenarios
#################################################################
    
# TODO: Calculator (fibonacci, factorial, prime number)
    
# TODO: Streaming video
    
# TODO: Image processing

#################################################################
# Main
#################################################################

if __name__ == "__main__":
    print("Starting server...")
    app.run(debug=True, host="0.0.0.0", port=5000)