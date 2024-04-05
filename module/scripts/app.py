#TODO from leds_process_control import DemoLedsController
from multiprocessing import Process, Condition
from zocket import socket_routine
from server import server_routine
import time

def termination():
    if socket_proc.is_alive():
        socket_proc.terminate()
    if server_proc.is_alive():
        server_proc.terminate()
    socket_proc.join()
    server_proc.join()
    socket_proc.close()
    server_proc.close()

if __name__ == "__main__":
    # leds = DemoLedsController()
    
    try:
        while True: #restart the server if it crash
            cond = Condition()
            socket_proc = Process(target=socket_routine, args=(cond,))
            server_proc = Process(target=server_routine)
            # leds.loading(255, 0, 0)
            socket_proc.start()
            server_proc.start()
            cond.acquire()
            cond.wait() # wait for socket connection
            # leds.loading_done()

            # leds.demoj()
            cond.wait() # wait for crash. or finish?
            cond.release()
            termination()
    except KeyboardInterrupt:
        pass
    finally:
        termination()
        # leds.close()
