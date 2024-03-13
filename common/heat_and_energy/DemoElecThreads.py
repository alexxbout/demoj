import threading
from threading import Lock
from rpi_ws281x import Color
from DemoLedsController import DemoLedsController
    
class DemoElecThread(threading.Thread):
    """
    A class to control the leds on an other thread 
    """
    def __init__(self, controller: DemoLedsController): 
        self.daemon = True
        self.__controller: DemoLedsController = controller

    def run(self): 
        try : 
            while True: # daemon so while true is not a problem
                self.__controller.demoj()
        except KeyboardInterrupt:
            pass
        except InterruptedError:
            pass
        finally:
            self.__gauges.clearAllSmoothed()
            