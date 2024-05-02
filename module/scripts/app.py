from leds_process_control import DemoLedsController
from multiprocessing import Process, Condition
from server import server_routine
import time

if __name__ == "__main__":
    leds = DemoLedsController()

    server_proc = Process(target=server_routine)
    server_proc.start()

    leds.loading(0, 0, 255)

    # Fake loading time for network module since it does not have a loading process based on sockets
    time.sleep(5)

    leds.loading_done()