from leds_process_control import DemoLedsController
from multiprocessing import Process
from server import server_routine
import time

if __name__ == "__main__":
    leds = DemoLedsController()
    try:

        server_proc = Process(target=server_routine)        

        leds.loading(0, 0, 255)
        server_proc.start()

        # Fake loading time for network module since it does not have a loading process based on sockets
        time.sleep(15)

        leds.loading_done()

        leds.demoj()
        
        server_proc.join()
    except KeyboardInterrupt:
        pass
    finally:
        leds.close()