import RPi.GPIO as GPIO
import time

# function to get CPU temperature
def getCPUtemperature():
    f = open("/sys/class/thermal/thermal_zone0/temp", "r")
    temp = int(f.readline())
    f.close()
    return temp/1000.0

GPIO.setmode(GPIO.BCM)

led1 = 27 # Vert
led2 = 22 # Bleu
led3 = 23 # Rouge

GPIO.setup(led1, GPIO.OUT)
GPIO.setup(led2, GPIO.OUT)
GPIO.setup(led3, GPIO.OUT)

try:
    while True:
        cpu = getCPUtemperature()
        if cpu >= 20:
            GPIO.output(led1, GPIO.HIGH)
            GPIO.output(led2, GPIO.LOW)
            GPIO.output(led3, GPIO.LOW)
        elif cpu >= 40:
            GPIO.output(led1, GPIO.HIGH)
            GPIO.output(led2, GPIO.HIGH)
            GPIO.output(led3, GPIO.LOW)
        elif cpu >= 60:
            GPIO.output(led1, GPIO.HIGH)
            GPIO.output(led2, GPIO.HIGH)
            GPIO.output(led3, GPIO.HIGH)
        else:
            GPIO.output(led1, GPIO.LOW)
            GPIO.output(led2, GPIO.LOW)
            GPIO.output(led3, GPIO.LOW)
        
        time.sleep(0.5)
except KeyboardInterrupt:
    pass
finally:
    GPIO.output(led1, GPIO.LOW)
    GPIO.output(led2, GPIO.LOW)
    GPIO.output(led3, GPIO.LOW)
    GPIO.cleanup()