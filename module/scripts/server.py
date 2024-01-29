from const import IP_NETWORK
from utils import execute_command
import socketio
import time
import threading

CURRENT_MODULE = "terminal"
TIMEOUT = 1

RESTART_CMD = ["sudo", "reboot"]
STOP_CMD = ["sudo", "shutdown", "-h", "now"]

sio = socketio.Client(reconnection=True, reconnection_attempts=10, reconnection_delay=5, reconnection_delay_max=5)
# received_event = threading.Event()

#################################################################
# Socket
#################################################################

@sio.event
def connect():
    """
    Send a message to the server to tell him that the module is ready
    Add the current module to be added in a room by the server
    """
    sio.emit("ready", {"device": CURRENT_MODULE})
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
    """
    We have to keep this while loop because the socketio will not reconnect automatically at the first try.
    Params for reconnection will be used if the socketio is disconnected while running.
    """
    while True:
        try:
            sio.connect("http://{}:5000".format(IP_NETWORK))
            break
        except socketio.exceptions.ConnectionError:
            print("Connection to server failed, retrying in 5 seconds")
            time.sleep(5)
    
    # """
    # This while loop is used to keep the socketio running.
    # The timeout parameter bellow is used to check if a message is received every x seconds.
    # Under this timeout, messages will be received and processed.
    # - Lower timeout: faster the message will be received.
    # - Higher timeout: chances are that the message will be processed after or not at all.
    # """
    # while True:
    #     try:
    #         message_received = received_event.wait(timeout=TIMEOUT)

    #         if message_received:
    #             print("Message received, doing stuff...")
    #             received_event.clear()
    #     except socketio.exceptions.ConnectionError:
    #         print("Connection lost, retrying in 5 seconds")
    #         time.sleep(5)
    
    # Simpler way to keep the socketio running
    # Note: We should handle the disconnection and reconnection in the socketio events
    sio.wait()