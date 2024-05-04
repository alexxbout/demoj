from leds_process_control import DemoLedsController
from multiprocessing import Process, Condition
from zocket import socket_routine

def termination():
    if socket_proc.is_alive():
        socket_proc.terminate()
    socket_proc.join()
    socket_proc.close()

if __name__ == "__main__":
    leds = DemoLedsController()
    
    try:
        while True:
            cond = Condition()
            socket_proc = Process(target=socket_routine, args=(cond,))
            leds.loading(0, 255, 0)
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
