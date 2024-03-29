from leds_process_control import DemoLedsController
import time

if __name__ == "__main__":
    leds = DemoLedsController()
    leds.loading()
    #animation should run in parallel
    time.sleep(20)
    leds.loading_done()
    try:
        leds.demoj()
        #run flask app
        while True:
            time.sleep(20)
    except KeyboardInterrupt:
        pass
    finally:
        leds.close()
    