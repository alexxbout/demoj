import threading
from threading import Lock
from rpi_ws281x import Color
from DemoLedsController import DemoLedsController
    
class DemoThread(threading.Thread):
    """
    A class to control the leds in a thread for demoj display 
    """
    def __init__(self, controller: DemoLedsController): 
        self.daemon = True
        self.__controller: DemoLedsController = controller
        self.__end = False
        
    def run(self): 
        while True: # daemon so while true is not a problem
            self.__controller.demoj()
            

class LoadingThread(threading.Thread):
    """
    A class to control the leds in a thread for loading displays
    """
    def __init__(self, controller: DemoLedsController): 
        self.daemon = True
        self.__controller: DemoLedsController = controller
        self.__end = False

    def done(self):
        """
        This method will join and exit the thread
        """
        self.__end = True
        self.join()

    def run(self):  
        while not self.__end: # daemon so while true is not a problem
            self.__controller.loading()
            self.__controller.loading_done()