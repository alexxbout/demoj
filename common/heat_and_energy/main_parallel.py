from leds_process_control import DemoLedsController
import time

if __name__ == "__main__":
    leds = DemoLedsController()
    leds.loading()
    #animation should run in parallel
    time.sleep(5)
    leds.loading_done()
    leds.demoj()
    time.sleep(5)
    #leds.end_animation()
    leds.close()
