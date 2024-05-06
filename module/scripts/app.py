from leds_process_control import DemoLedsController
import time

if __name__ == "__main__":
    leds = DemoLedsController()
    try:
        leds.loading(0, 0, 255)

        # Fake loading time for network module since it does not have a loading process based on sockets
        time.sleep(15)

        leds.loading_done()

        leds.demoj()

        while (True):
            time.sleep(10)
    except KeyboardInterrupt:
        pass
    finally:
        leds.close()