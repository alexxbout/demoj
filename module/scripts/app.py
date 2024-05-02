from leds_process_control import DemoLedsController
from multiprocessing import Process, Condition
from zocket import socket_routine
import time

def termination():
    if socket_proc.is_alive():
        socket_proc.terminate()
    socket_proc.join()
    socket_proc.close()

if __name__ == "__main__":
    leds = DemoLedsController()
    
    try:
        while True: #restart the server if it crash
            cond = Condition()
            socket_proc = Process(target=socket_routine, args=(cond,))
            leds.loading(255, 0, 0)
            socket_proc.start()
            cond.acquire()
            cond.wait() # wait for socket connection
            leds.loading_done()

            leds.demoj()
            cond.wait() # wait for crash. or finish?
            cond.release()
            termination()
    except KeyboardInterrupt:
        pass
    finally:
        termination()
        leds.close()
