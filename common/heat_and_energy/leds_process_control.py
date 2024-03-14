from multiprocessing import Lock, Semaphore, Process
import time
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

class ConccurentAnimation(Exception):
    """
    When an other animation is requested while an other animation still running
    """
    def __init__(self, message="Conccurrent animation request detected!"):
        self.message = message
        super().__init__(self.message)

class DemoLedsController:
    """
    A small class to coordinates processes in order to mannipulate the DemoJ Leds with some animations senarios.
    """
    def __init__(self):
        self.__gauges = Gauges(LED_COUNT, CHANNEL, LED_PIN)
        self.__isAnimated = False
        self.__running: Process = None
        try:
            self.__wattmeter = Wattmeter
        except WattmeterTimeout:
            print("Wattmeter timed out on init")
        self.__gauges.clearAll()

    def is_running(self) -> bool:
        """
        If an animation process still running. You should run end_animation to end the current process.
        """
        return self.__running != None and self.__running.is_alive()
    
    def __loading_rootine(gauges: Gauges):
        while True:
            gauges.blinkColorSmoothed(RED, 3)            

    def loading(self):
        """
        Start the loading led animation process.

        RAISES:
            ConccurentAnimation if the previous animation wasn't terminated.
        """
        if self.is_running(): 
            raise ConccurentAnimation()
        self.__running = Process(target=self.__loading_rootine, args=(self.__gauges), daemon=True)
    
    def end_animation(self): 
        """
        End the current running animation. isRunning will return False and all leds will be cleared smoothly
        """
        if self.__running == None: 
            return
        self.__running.close() # let's try this
        self.__gauges.clearAllSmoothed()

    def loading_done(self):
        """
        This method call end_animation and display green leds for 1 second
        """
        self.end_animation()
        self.__gauges.fillColorSmoothed(GREEN)
        time.sleep(1)

    def __demoj_rootine(self):
        while True:
            temp: float = getCPUtemperature()
            watts: float = self.__wattmeter.getWattsMW()
            self.__gauges.displayTemp(temp)
            self.__gauges.displayWatts(watts)
            time.sleep(SPEED)
            print(f"temperature : {temp}")
            print(f"watts: {watts/1000}")
    
    def demoj(self):
        """
        Start the demoj gauges default animation process 
        """
        if self.is_running(): 
            raise ConccurentAnimation()
        self.__running = Process(target=self.__demoj_rootine, args=(self.__gauges, self.__wattmeter), daemon=True)