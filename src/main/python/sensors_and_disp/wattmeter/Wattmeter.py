# DFRobot Library: https://github.com/DFRobot/DFRobot_INA219/
# AUTHORS of this file : DEMOTECH
import sys
import time
# sys.path.append("../lib") not if PYTHONPATH is defined into env.
from dfrobot.DFRobot_INA219 import INA219
import WattmeterTimeout


class Wattmeter:
    """
    This class represent a Wattmeter. But this wattmeter can't be used used in other cases than our project. 
    """ 
    
    def __begin(self):
        """
        Begin the wattmeter execution

        EXCEPTION:
        WattmeterTimeout If the wattmeter don't begin
        """
        last_time = time.time()
        while not self.__ina.begin():
            time.sleep(1)
            if (time.time() - last_time) >= 5 :
                raise WattmeterTimeout("Wattmeter init timeout")
        ina219_reading_mA = 1000 # The current measured by INA219 (before calibration)
        ext_meter_reading_mA = 1000 # Actual measured current
        self.__ina.linear_cal(ina219_reading_mA, ext_meter_reading_mA)

    def __init__(self):
        """
        Constructor
        EXCEPTION:
        WattmeterTimeout If the wattmeter don't begin
        """
        self.__ina = INA219(1, INA219.INA219_I2C_ADDRESS4)
        self.__begin()

    def getWattsMW(self):
        """Get watts in mW"""
        return self.__ina.get_power_mW()