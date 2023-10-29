import RPi.GPIO as GPIO
from enum import Enum


class Color(Enum):
    GREEN = 27
    BLUE = 22
    RED = 23


def light_on(color):
    GPIO.output(color.value, GPIO.HIGH)


def light_off(color):
    GPIO.output(color.value, GPIO.LOW)
