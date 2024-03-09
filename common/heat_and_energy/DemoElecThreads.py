import threading
from threading import Lock
import time
from leds.DemoDisplay import Gauges
from temperature.temp import getCPUtemperature
from wattmeter.DemoWattmeter import *

SPEED = 0.5 
LED_COUNT = 30
CHANNEL = 0
LED_PIN = 18    
    
class DemoElecThread(threading.Thread):
    """
    A class to control the leds on an other thread 
    """
    def __init__(self): 
        self.daemon = True
        self.__lock: Lock = Lock()
        self.__gauges = Gauges(LED_COUNT, CHANNEL, LED_PIN)
        try:
            self.__wattmeter = Wattmeter
        except WattmeterTimeout:
            print("Wattmeter timed out on init")
        self.__gauges.clearAll()
        self.__routine: function = self.__demoj_routine

    def __demoj_routine(self):
        temp: float = getCPUtemperature()
        watts: float = self.__wattmeter.getWattsMW()
        self.__gauges.displayTemp(temp)
        self.__gauges.displayWatts(watts)
        time.sleep(SPEED)
        print(f"temperature : {temp}")
        print(f"watts: {watts/1000}")

    def __waiting_routine(self):
        pass #TODO

    def waiting_mode(self):
        self.__lock.acquire()
        self.__routine = self.__waiting_routine
        self.__lock.release()

    def demoj_mode(self): #syncronisation if async methods are used by the app
        self.__lock.acquire()
        self.__routine = self.__demoj_routine
        self.__lock.release()

    def run(self): 
        try : 
            while True: # daemon so while true is not a problem
                self.__routine()
        except KeyboardInterrupt:
            pass
        except InterruptedError:
            pass
        finally:
            self.__gauges.clearAll()
            