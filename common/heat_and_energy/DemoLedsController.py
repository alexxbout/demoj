from threading import Lock, Condition
import time
import threading
from leds.DemoDisplay import Gauges
from temperature.temp import getCPUtemperature
from wattmeter.DemoWattmeter import *
from rpi_ws281x import Color

SPEED = 0.5 
LED_COUNT = 30
CHANNEL = 0
LED_PIN = 18    
BLACK = Color(0, 0, 0, 0)
RED = Color(255, 0, 0, 0)
GREEN = Color(0, 255, 0, 0)

#On aurait aussi pu tout faire avec un seul thread mais j'avais un doute sur la synchro
#car la routine du thread dépendrait de l'extérieur 
#TODO dire ou faire si vous trouvez que c'est mieux avec un seul je pense que ce serais peut-être plus pertinant

class DemoLedsController:
    """
    A small class to coordinates threads in order to mannipulate the DemoJ Leds with some animations senarios.
    """

    def __init__(self):
        lock: Lock = Lock()
        self.__cond: Condition = Condition(lock)
        self.__gauges = Gauges(LED_COUNT, CHANNEL, LED_PIN)
        try:
            self.__wattmeter = Wattmeter
        except WattmeterTimeout:
            print("Wattmeter timed out on init")
        self.__gauges.clearAll()
        self.__animate: bool = True
    
    def loading(self):
        self.__cond.acquire()
        self.__gauges.blinkColorSmoothed(RED)
        self.__animate = False
        self.__cond.release()

    def loading_done(self): 
        self.__cond.acquire()
        self.__gauges.fillColorSmoothed(GREEN)
        self.__animate = True
        self.__cond.notify()
        self.__cond.release()

    def demoj(self):
        self.__cond.acquire()
        while not self.__animate:
            self.__cond.wait()
        temp: float = getCPUtemperature()
        watts: float = self.__wattmeter.getWattsMW()
        self.__gauges.displayTemp(temp)
        self.__gauges.displayWatts(watts)
        time.sleep(SPEED)
        print(f"temperature : {temp}")
        print(f"watts: {watts/1000}")
        self.__cond.release()

    def end_show(self):
        self.__cond.acquire()
        #you can add animations if you want
        self.__gauges.clearAllSmoothed()
        self.__animate = False
        self.__cond.release()