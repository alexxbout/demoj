import threading
import time
from leds.DemoDisplay import Gauges
from temperature.temp import getCPUtemperature
from wattmeter.DemoWattmeter import *

SPEED = 0.5 #20ms
LED_COUNT = 30
CHANNEL = 0
LED_PIN = 18    
    
"""
A class to control the leds on an other thread 
"""
class DemoElecThread(threading.Thread):
    def __init__(self): 
        self.daemon = True
        self.__gauges = Gauges(LED_COUNT, CHANNEL, LED_PIN)
        try:
            self.__wattmeter = Wattmeter
        except WattmeterTimeout:
            print("Wattmeter timed out on init")
        self.__gauges.clearAll()

    def __demoj_routine(self):
        temp: float = getCPUtemperature()
        watts: float = self.__wattmeter.getWattsMW()
        self.__gauges.displayTemp(temp)
        self.__gauges.displayWatts(watts)
        time.sleep(SPEED)
        print(f"temperature : {temp}")
        print(f"watts: {watts/1000}")

    def run(self): 
        try : 
            while True: # daemon so while true is not a problem
                self.__demoj_routine()
        except KeyboardInterrupt:
            pass
        except InterruptedError:
            pass
        finally:
            self.__gauges.clearAll()
            