from leds_process_control import DemoLedsController
import time

if __name__ == "__main__":
    leds = DemoLedsController()
    try:
        leds.loading()
        #launch flask
        time.sleep(20)
        leds.loading_done()
        leds.demoj()
        
        while True:
            time.sleep(20)
    except KeyboardInterrupt:
        pass
    finally:
        leds.close()
    