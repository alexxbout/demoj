from flask import Flask, jsonify
from flask_cors import CORS
from utils import execute_command
from const import STOP_CMD, RESTART_CMD, IP_NETWORK
import socketio
import time

APP_FOLDER = "../app"
APP_URL = "/app/"
HTTP_SERVER_PORT = 5000
SOCKET_SERVER_PORT = 5000
CURRENT_MODULE = "server"

app = Flask(__name__, template_folder=APP_FOLDER, static_folder=APP_FOLDER, static_url_path=APP_URL)
CORS(app)

sio = socketio.Client(reconnection=True, reconnection_attempts=10, reconnection_delay=5, reconnection_delay_max=5)

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
# Socket
#################################################################

@sio.event
def connect():
    print("Connected to network")

@sio.event
def disconnect():
    print("Disconnected from network")

@sio.event
def stop():
    print("Stopping module...")
    sio.disconnect()
    execute_command(STOP_CMD)

@sio.event
def restart():
    print("Restarting module...")
    sio.disconnect()
    execute_command(RESTART_CMD)

#################################################################
# Main
#################################################################

if __name__ == "__main__":
    print("Connecting to network socket...")
    while True:
        try:
            sio.connect("http://{}:{}".format(IP_NETWORK, SOCKET_SERVER_PORT))
            break
        except socketio.exceptions.ConnectionError:
            print("Connection to network socket failed, retrying in 5 seconds")
            time.sleep(5)

    sio.wait()
    
    print("Starting server...")
    app.run(debug=True, host="0.0.0.0", port=HTTP_SERVER_PORT)
