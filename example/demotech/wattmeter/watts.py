import time
import sys
sys.path.append("../../../src/main/python/sensors_and_display")

import wattmeter.Wattmeter
import wattmeter.WattmeterTimeout

try:
    w = Wattmeter()
    print(w.getWattsMW())
except WattmeterTimeout:
    sys.exit(1)
