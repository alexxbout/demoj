#TODO from leds_process_control import DemoLedsController
from multiprocessing import Process, Condition
from server import server_routine
import time

def termination():
    if server_proc.is_alive():
        server_proc.terminate()
    server_proc.join()
    server_proc.close()

if __name__ == "__main__":
    # leds = DemoLedsController()
    
    try:
        while True: #restart the server if it crash
            cond = Condition()
            server_proc = Process(target=server_routine)
            # leds.loading(255, 0, 0)
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
