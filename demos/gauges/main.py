import time
from leds.DemoDisplay import Gauges
from temperature.temp import getCPUtemperature
from wattmeter.DemoWattmeter import *

SPEED = 0.5 #20ms
LED_COUNT = 30
CHANNEL = 0
LED_PIN = 18

if __name__ == "__main__":
    gauges = Gauges(LED_COUNT, CHANNEL, LED_PIN)
    try:
        wattmeter = Wattmeter()
        while True:
            temp: float = getCPUtemperature()
            watts: float = wattmeter.getWattsMW()
            gauges.displayTemp(temp)
            gauges.displayWatts(watts)
            time.sleep(SPEED)
            print(f"temperature : {temp}")
            print(f"watts: {watts/1000}")
    except KeyboardInterrupt:
        pass
    except WattmeterTimeout:
        print("Wattmeter timed out on init")
    finally:
        gauges.clearAll()
