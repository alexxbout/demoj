import RPi.GPIO as GPIO
import time

#defining all led pins
led1 = 22
led2 = 23
led3 = 27
#defining a default speed
speed = 0.100
#Setting the pin addressing mode
GPIO.setmode(GPIO.BCM)

#Defining a function to set the led on
def on(gpio_pin):
    GPIO.output(gpio_pin, GPIO.HIGH)

#Defining a function to set the led off
def off(gpio_pin):
    GPIO.output(gpio_pin, GPIO.LOW)

#Tells that all pins will be for output only
GPIO.setup(gpio_pin, GPIO.OUT)
GPIO.setup(gpio_pin, GPIO.OUT)
GPIO.setup(gpio_pin, GPIO.OUT)

try: #We surround with try catch for program exit 
    while True: #Here is the light show program
        on(led1)
        time.sleep(speed) #process sleep
        on(led2)
        time.sleep(speed)
        on(led3)
        time.sleep(speed)
        off(led1)
        time.sleep(speed)
        off(led2)
        time.sleep(speed)
        off(led3)
        time.sleep(speed)
except KeyboardInterrupt:
        pass
finally: #Code to always execute at the end
    off(led1)
    off(led2)
    off(led3)
    GPIO.cleanup()