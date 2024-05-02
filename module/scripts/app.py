from leds_process_control import DemoLedsController
from multiprocessing import Process, Condition
from zocket import socket_routine
import time
from rpi_ws281x import Color

def termination():
    if socket_proc.is_alive():
        socket_proc.terminate()
    socket_proc.join()
    socket_proc.close()

if __name__ == "__main__":
    leds = DemoLedsController(Color(255, 0, 0))
    
    try:
        while True: #restart the server if it crash
            cond = Condition()
            socket_proc = Process(target=socket_routine, args=(cond,))
            leds.loading()
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
