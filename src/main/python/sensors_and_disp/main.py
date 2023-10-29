import RPi.GPIO as GPIO
import time
import sys
from leds import Color, lightOn, lightOff
from temp import getCPUtemperature

default_increment = 20
default_sleep = 0.5


def setup():
    GPIO.setmode(GPIO.BCM)

    for color in Color:
        GPIO.setup(color.value, GPIO.OUT)


def set_leds_based_on_temperature(cpu_temp, increment):
    if cpu_temp >= increment * 3:
        lightOn(Color.GREEN)
        lightOn(Color.BLUE)
        lightOn(Color.RED)
    elif cpu_temp >= increment * 2:
        lightOn(Color.GREEN)
        lightOn(Color.BLUE)
        lightOff(Color.RED)
    elif cpu_temp >= increment:
        lightOn(Color.GREEN)
        lightOff(Color.BLUE)
        lightOff(Color.RED)
    else:
        lightOff(Color.GREEN)
        lightOff(Color.BLUE)
        lightOff(Color.RED)


if __name__ == "__main__":
    try:
        lightOff(Color.GREEN)
        lightOff(Color.BLUE)
        lightOff(Color.RED)

        increment = float(sys.argv[1]) if len(sys.argv) > 1 else default_increment

        setup()

        while True:
            temp = getCPUtemperature()
            set_leds_based_on_temperature(temp, increment)
            print("CPU temp: {}".format(temp))
            time.sleep(default_sleep)
    except KeyboardInterrupt:
        pass
    finally:
        lightOff(Color.GREEN)
        lightOff(Color.BLUE)
        lightOff(Color.RED)
        GPIO.cleanup()
