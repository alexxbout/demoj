# This is a sample code from the official example from DFRobot
# Source: https://github.com/DFRobot/DFRobot_INA219/blob/master/Python/RespberryPi/examples/set_config/set_config.py

import sys
import time
# sys.path.append("../lib") if PYTHONPATH is not defined into env.
from sensors.DFRobot_INA219 import INA219

ina219_reading_mA = 1000 # The current measured by INA219 (before calibration)
ext_meter_reading_mA = 1000 # Actual measured current

ina = INA219(1, INA219.INA219_I2C_ADDRESS4)

last_time = time.time()
#begin return True if succeed, otherwise return False
while not ina.begin():
    time.sleep(1)
    if (time.time() - last_time) >= 5 :
        sys.exit(1) # Timeout
    

ina.linear_cal(ina219_reading_mA, ext_meter_reading_mA) # linear calibration

def main():
    while True:
        time.sleep(1)
        print ("Shunt Voltage : %.2f mV" % ina.get_shunt_voltage_mV())
        print ("Bus Voltage   : %.3f V" % ina.get_bus_voltage_V())
        print ("Current       : %.f mA" % ina.get_current_mA())
        print ("Power         : %.f mW" % ina.get_power_mW())
        print (" ")

if __name__ == "__main__":
    main()