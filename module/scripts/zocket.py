from utils import execute_command
from const import STOP_CMD, RESTART_CMD, IP_NETWORK
import socketio
import time

HTTP_SERVER_PORT = 5000
SOCKET_SERVER_PORT = 5000
CURRENT_MODULE = "server"

sio = socketio.Client(reconnection=True, reconnection_attempts=10, reconnection_delay=5, reconnection_delay_max=5)
cond_global = None

#################################################################
# Socket
#################################################################

@sio.event
def connect():
    print("Connected to network")

@sio.event
def disconnect():
    print("Disconnected from network")

    # Notifying the main process to restart the socket
    global cond_global
    cond_global.notify()

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

def socket_routine(cond):
    global cond_global
    cond_global = cond

    print("Connecting to network socket...")
    while True:
        try:
            sio.connect("http://{}:{}".format(IP_NETWORK, SOCKET_SERVER_PORT))
            break
        except socketio.exceptions.ConnectionError:
            print("Connection to network socket failed, retrying in 5 seconds")
            time.sleep(5)

    cond.notify()
    sio.wait()