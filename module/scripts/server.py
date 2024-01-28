from const import IP_NETWORK
import socketio
import time
import threading

CURRENT_MODULE = "terminal"

sio = socketio.Client(reconnection=True, reconnection_attempts=10, reconnection_delay=5, reconnection_delay_max=5)
received_event = threading.Event()

@sio.event
def connect():
    """
    Send a message to the server to tell him that the module is ready
    Add the current module to be added in a room by the server
    """
    sio.emit("module_ready", {"module": CURRENT_MODULE})
    print("Connected to network")

@sio.event
def disconnect():
    print("Disconnected from network")

@sio.event
def custom_message(data):
    print(f"Received custom message: {data}")
    received_event.set()

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
    
    while True:
        try:
            message_received = received_event.wait(timeout=5)

            if message_received:
                print("Message received, exiting.")
                break
        except socketio.exceptions.ConnectionError:
            print("Connection lost, retrying in 5 seconds")
            time.sleep(5)