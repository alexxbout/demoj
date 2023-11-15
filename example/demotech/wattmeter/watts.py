import time
import sys
sys.path.append("../../../src/main/python/sensors_and_disp/wattmeter")

from DemoWattmeter import Wattmeter, WattmeterTimeout

try:
    w = Wattmeter()
    print(w.getWattsMW())
except WattmeterTimeout:
    sys.exit(1)
