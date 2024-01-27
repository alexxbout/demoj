from const import IP_NETWORK
import socketio

sio = socketio.Client()

@sio.event
def connect():
    print("Connected to server")

# Function called when the client receives a message from the server
@sio.event
def message(data):
    print("Received message:", data)

# Function called when the client disconnects from the server
@sio.event
def disconnect():
    print("Disconnected from server")

# Connect the client to the server (replace the IP address with that of your server)
sio.connect('http://{}:5000'.format(IP_NETWORK))

# Send a message to the server
sio.emit('message', 'Hello from client')

# Wait for 5 seconds
sio.sleep(5)

# Disconnect from the server
sio.disconnect()