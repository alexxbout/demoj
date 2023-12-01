"""
Prérequis de configuration avant utilisation :
sudo pip3 install rpi_ws281x
sudo apt-get install python-dev python-rpi.gpio

"""

"""Imports des modules nécéssaires"""
import RPi.GPIO as GPIO
from rpi_ws281x import PixelStrip, Color
import time

"""Variables et initialisation"""
RED = Color(255, 0, 0)
GREEN = Color(0, 255, 0)
YELLOW = Color(255, 255, 0)
NONE = Color(0, 0, 0)

NBLEDSTEMP = 15
NBLEDSPOW = 15
NBLEDS = NBLEDSTEMP + NBLEDSPOW

MAXTEMP = 80 # Temperature (en degrés Celcius) max affichable
MAXPOW = 10 # Puissance (en Watts) max affichable

# Paramètres par défaut de DemoJ1
PIN = 17
FREQ = 800000
DMA = 10
BRIGHTNESS = 100
INVERT = False
CHANNEL = 0

# Initialisation
strip = PixelStrip(NBLEDS, PIN, FREQ, DMA, INVERT, BRIGHTNESS, CHANNEL)
strip.begin()

"""Usage de la bande LED"""

# Fonction à appeler pour utiliser les LEDs
def LED(temperature, power):
    temperature = (temperature/MAXTEMP)*NBLEDSTEMP # Donne le nombre de LEDs à allumer
    power = power/(MAXPOW)*NBLEDSPOW
    for i in range (0, int(temperature)):
        strip.setPixelColor(i, getColor(i))
        strip.show()

    for i in range (NBLEDSTEMP, NBLEDSTEMP+int(power)):
        strip.setPixelColor(i, getColor(i))
        strip.show()

# Retourne la couleur de la LED n
def getColor(n):
    if((n<NBLEDSTEMP/3) or (n>=NBLEDSTEMP and n<NBLEDSTEMP+(NBLEDSPOW/3))): return GREEN
    elif((n<(NBLEDSTEMP/3)*2) or (n>=NBLEDSTEMP+(NBLEDSPOW/3) and n<NBLEDSTEMP+((NBLEDSPOW/3)*2))): return YELLOW
    else: return RED
   

# Eteint l'ensemble des LEDs
def turnOff():
    for i in range (0, NBLEDS):
        strip.setPixelColor(i, NONE)
        strip.show()

"""Demo"""

LED(10, 2)
time.sleep(1)
turnOff()
LED(40, 5)
time.sleep(1)
turnOff()
LED(70, 9)
time.sleep(1)
turnOff()

print("Success")






