import time
from leds.DemoDisplay import Gauges
from temperature.temp import getCPUtemperature
from wattmeter.DemoWattmeter import *
#from battery.battery import Battery

SPEED = 0.5 #20ms
LED_COUNT = 30
CHANNEL = 0
LED_PIN = 18
MAX_VOLT: float = 5.0
MIN_ACCEPTABLE_VOLT: float = 3.7

if __name__ == "__main__":
    try:
        wattmeter = Wattmeter()
        #battery = Battery(wattmeter, MIN_ACCEPTABLE_VOLT, MAX_VOLT)
        gauges = Gauges(LED_COUNT, CHANNEL, LED_PIN)
        while True:
            temp: float = getCPUtemperature()
            watts: float = wattmeter.getWattsMW()
            gauges.displayTemp(temp)
            gauges.displayWatts(watts)
            time.sleep(SPEED)
            print(f"temperature : {temp}")
            print(f"watts: {watts/1000}")
            #print(f"ma = {battery.getCharge()} %")
    except KeyboardInterrupt:
        pass
    except WattmeterTimeout:
        print("Wattmeter timed out on init")
    finally:
        gauges.clearAll()
