import time
from leds.DemoDisplay import Gauges
from temperature.temp import getCPUtemperature

SPEED = 0.5
LED_COUNT = 30
CHANNEL = 0
LED_PIN = 18

if __name__ == "__main__":
    gauges = Gauges(LED_COUNT, CHANNEL, LED_PIN)
    try:
        while True:
            temp: float = getCPUtemperature()
            gauges.displayTemp(temp)
            time.sleep(SPEED)
    except KeyboardInterrupt:
        pass
    finally:
        gauges.clearAll()
