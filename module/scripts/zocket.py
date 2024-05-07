from utils import execute_command
from const import STOP_CMD, RESTART_CMD, IP_NETWORK, STRESS_CMD
from stressTerm import stress_compute
import multiprocessing as mp
import socketio
import time

HTTP_SERVER_PORT = 5000
SOCKET_SERVER_PORT = 5000
CURRENT_MODULE = "terminal"

sio = socketio.Client(reconnection=True, reconnection_attempts=10, reconnection_delay=5, reconnection_delay_max=5)
cond_global = None
stress_pid = -1

#################################################################
# Socket
#################################################################

def notifyMain():
    global cond_global
    with cond_global:
        cond_global.notify()	

@sio.event
def connect():
    print("Connected to network")
    notifyMain() # Notify the main process to stop loading animation and start demoj animation


@sio.event
def disconnect():
    print("Disconnected from network")

    # Notifying the main process to restart the socket
    notifyMain()

@sio.event
def stop():
    print("Stopping module...")
    execute_command(STOP_CMD)

@sio.event
def restart():
    print("Restarting module...")
    execute_command(RESTART_CMD)

@sio.event
def stress(time):
    print("Stressing module...")
    cmd = STRESS_CMD
    cmd[-1] = str(time)
    print(cmd)
    execute_command(cmd)

@sio.event
def calculation(value):
    global stress_pid
    if (value == True and stress_pid == -1):
        print("Stressing terminal...")
        proc = mp.Process(target=stress_compute)
        proc.start()
        stress_pid = proc.pid
        proc.join() # Never reached
    else:
        print("Stop stressing terminal...")
        if (value == False and stress_pid != -1):
            execute_command(["kill ", str(stress_pid)])
            stress_pid = -1

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
    #with cond:
    #    cond.notify()
    # I added this in events instead
    sio.wait()
