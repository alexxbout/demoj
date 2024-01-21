import sys
sys.path.append("../../common/heat_and_energy/wattmeter")
from DemoWattmeter import Wattmeter, WattmeterTimeout

try:
    w = Wattmeter()
    print(w.getWattsMW())
except WattmeterTimeout:
    sys.exit(1)
