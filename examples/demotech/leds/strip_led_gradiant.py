# DEMOTECH Example for using strip leds with a gradiant color

from rpi_ws281x import PixelStrip, Color
import time

# LED strip configuration:
LED_COUNT = 30       # Number of LED pixels.
LED_PIN = 18          # GPIO pin connected to the pixels (18 uses PWM!).
LED_FREQ_HZ = 800000  # LED signal frequency in hertz (usually 800khz)
LED_DMA = 10          # DMA channel to use for generating signal (try 10)
LED_BRIGHTNESS = 128  # Set to 0 for darkest and 255 for brightest
LED_INVERT = False    # True to invert the signal (when using NPN transistor level shift)
LED_CHANNEL = 0       # set to '1' for GPIOs 13, 19, 41, 45 or 53
BEGIN_COLOR = Color(0, 255, 0)
ENDING_COLOR = Color(255, 0, 0)

strip = PixelStrip(LED_COUNT, LED_PIN, LED_FREQ_HZ, LED_DMA, LED_INVERT, LED_BRIGHTNESS, LED_CHANNEL)
SPEED = 0.010

def wipe(strip: PixelStrip, color: Color):
    pixels = strip.numPixels()
    for i in range(pixels):
        strip.setPixelColor(i, color)
        strip.show()
        time.sleep(SPEED) # For something animated

def wipeRev(strip: PixelStrip, color: Color):
    pixels = strip.numPixels()
    for i in range(pixels):
        strip.setPixelColor(pixels-i-1, color)
        strip.show()
        time.sleep(SPEED) # For something animated

def degrade(i: int, max: int, begin: Color, end: Color): 
    percent = i / max
    red = int(begin.r + percent * (end.r - begin.r))
    green = int(begin.g + percent * (end.g - begin.g))
    blue = int(begin.b + percent * (end.b - begin.b))
    return Color(red, green, blue)

def degradeAll(strip: PixelStrip):
    for i in range(strip.numPixels()):
        strip.setPixelColor(i, degrade(i, strip.numPixels(), BEGIN_COLOR, ENDING_COLOR))
        strip.show()
        time.sleep(SPEED)

def degradeAllRev(strip: PixelStrip):
    pixels = strip.numPixels()
    for i in range(pixels):
        strip.setPixelColor(pixels-i-1, degrade(i, strip.numPixels(), BEGIN_COLOR, ENDING_COLOR))
        strip.show()
        time.sleep(SPEED)

strip.begin()
BLACK = Color(0, 0, 0)
try:
    while True:
        degradeAll(strip)
        time.sleep(2)
        wipe(strip, BLACK)
        degradeAllRev(strip)
        time.sleep(2)
        wipeRev(strip, BLACK)

except KeyboardInterrupt:
    wipe(strip, BLACK)
