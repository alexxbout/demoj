# DEMOTECH

from rpi_ws281x import PixelStrip, Color
import time

MAX_TEMP = 65
MIN_TEMP = 30
MAX_WATTS = 12500 # 2,5 A * 5 V
NB_OF_GAUGES = 2
NO_COLOR = Color(0, 0, 0, 0)

class Gauges:
    """
    Gauges to display temperature and watts
    temperature = leds from 0 until nbOfLeds/2
    watts = leds from nbOfLeds/2 until nbOfLeds 
    """
    def __begin(self):
        self.__strip.begin()

    def __init__(self, led_count: int, channel: int, led_pin: int):
        """ Constructor for the demoj led gauges Temperature and Wattmeter

        Params:
            - led_count Number of leds on the strip led (all)
            - channel Set to '1' for GPIOs 13, 19, 41, 45 or 53
            - led_pin The GIPIO PIN number according to the channel chosen
        """
        # LED strip configuration:
        self.__led_count = led_count # Number of LED pixels.
        self.__ledsPerGauge = int(led_count/NB_OF_GAUGES)
        self.__tempStep = self.__ledsPerGauge/(MAX_TEMP - MIN_TEMP)
        self.__wattStep = self.__ledsPerGauge/MAX_WATTS
        LED_PIN = led_pin          # GPIO pin connected to the pixels (18 uses PWM!).
        LED_FREQ_HZ = 800000  # LED signal frequency in hertz (usually 800khz)
        LED_DMA = 10          # DMA channel to use for generating signal (try 10)
        LED_BRIGHTNESS = 128  # Set to 0 for darkest and 255 for brightest
        LED_INVERT = False    # True to invert the signal (when using NPN transistor level shift)
        LED_CHANNEL = channel      
        self.__begin_color = Color(0, 255, 0) #GREEN
        self.__ending_color = Color(255, 0, 0) #RED
        self.__strip = PixelStrip(led_count, LED_PIN, LED_FREQ_HZ, LED_DMA, LED_INVERT, LED_BRIGHTNESS, LED_CHANNEL)
        self.__begin()

    def __gradiant(self, step: int, maxStep: int, begin: Color, end: Color): 
        """
        Calculate the gradiant color for the current step

        PARAMS: 
            - step The current step
            - maxStep The max value for a step
            - begin The begin color
            - end The ending color
        """
        percent = step / maxStep
        red = int(begin.r + percent * (end.r - begin.r))
        green = int(begin.g + percent * (end.g - begin.g))
        blue = int(begin.b + percent * (end.b - begin.b))
        return Color(red, green, blue)

    def __clearLeds(self, begin: int, end: int):
        """
        Clear all leds in the given interval

        PARAMS:
            - begin Should be less than end (inclusive)
            - end Should be greater than begin (exclusive)
        """
        for i in range(begin, end):
            self.__strip.setPixelColor(i, NO_COLOR)

    def __gradiantLeds(self, begin: int, end: int, maxStep: int):
        """
        Colorize all leds in the given interval using gradiant method
        PARAMS:
            - begin Should be less than end (inclusive)
            - end Should be greater than begin (exclusive)
            - maxStep The max value for a step
        """
        for i in range(begin, end):
            self.__strip.setPixelColor(i, self.__gradiant(i, maxStep, self.__begin_color, self.__ending_color))

    def displayTemp(self, degrees: float): 
        """
        Display the current value to the temperature gauge

        PARAMS:
            - degrees The temperature in celsius degrees
        """
        colored_leds: int = int((degrees - MIN_TEMP) * self.__tempStep)
        gaugeEnd = self.__ledsPerGauge
        self.__gradiantLeds(0, colored_leds, gaugeEnd)
        self.__clearLeds(colored_leds, gaugeEnd)
        self.__strip.show() #show at the end of calculation

    def displayWatts(self, miliWatts: float): 
        """
        Display the current value to the wattmeter gauge

        PARAMS:
            - miliWatts The power in miliwatts
        """
        colored_leds: int = int(miliWatts * self.__wattStep)
        colorEnd = self.__ledsPerGauge+colored_leds
        self.__gradiantLeds(self.__ledsPerGauge, colorEnd, self.__ledsPerGauge)
        self.__clearLeds(colorEnd, self.__led_count)
        self.__strip.show() #show at the end of calculation
        
    def clearAll(self):
        """Clear all the leds"""
        self.__clearLeds(0, self.__led_count)
        self.__strip.show()
