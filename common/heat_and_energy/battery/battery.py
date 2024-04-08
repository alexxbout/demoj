from wattmeter.DemoWattmeter import Wattmeter

PERCENT_AVG = 0.5

#TODO pas fiable mais nécessaire?

class Battery:

    def __init__(self, wattmeter: Wattmeter, min: float, max: float):
        self.__wattmeter = wattmeter
        self.__max = max
        self.__min = min
        self.__maxDiff = self.__max - self.__min
        self.__last_value = (self.__maxDiff / (self.__wattmeter.getVoltsV() - self.__min)) * 100

    def getCharge(self) -> float:
        volts = self.__wattmeter.getVoltsV()
        print("get volt = ", volts)
        actDiff = volts - self.__min
        percentage = (actDiff / self.__maxDiff) * 100
        percentage = self.__instantAverage(self.__last_value, percentage, PERCENT_AVG)
        self.__last_value = percentage
        return percentage
    
    def __instantAverage(self, lastValue: float, newValue: float, percent: float) -> float:
        """
        Instant average on floats
        
        PARAMS:
            - lastValue The last value evaluated.
            - newValue The new value to add
            - percent A real between 0 and 1. 
                The factor for the balance between lastValue and newValue.

        RETURNS: The instant average.
        """
        return percent * newValue + (1 - percent) * lastValue