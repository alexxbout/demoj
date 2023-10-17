import RPi.GPIO as gpio
import time


gpio.setmode(gpio.BOARD)

led1 = 27
led2 = 22
led3 = 23

gpio.setup(led1, gpio.OUT)
gpio.setup(led2, gpio.OUT)
gpio.setup(led3, gpio.OUT)

while True :
    gipo.output(led1, gpio.HIGH)
    gipo.output(led2, gpio.HIGH)
    gipo.output(led3, gpio.HIGH)
    time.sleep(1)
    gipo.output(led1, gpio.LOW)
    gipo.output(led2, gpio.LOW)
    gipo.output(led3, gpio.LOW)
    time.sleep(1)

gpio.cleanup()