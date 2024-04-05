#TODO from leds_process_control import DemoLedsController
from multiprocessing import Process, Condition
from zocket import socket_routine
from server import server_routine
import time

if __name__ == "__main__":
    # leds = DemoLedsController()
    cond = Condition()
    socket_proc = Process(target=socket_routine, args=(cond,))
    socket_proc.start()
    
    server_proc = Process(target=server_routine)
    server_proc.start()
    try:
        while True:
            # leds.loading(255, 0, 0)
            cond.acquire()
            cond.wait() # wait for socket connection
            # leds.loading_done()

            # leds.demoj()
            cond.wait() # wait for crash. or finish?
            cond.release()
    except KeyboardInterrupt:
        pass
    # finally:
        # leds.close()
