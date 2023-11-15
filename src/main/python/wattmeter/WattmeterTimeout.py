# AUTHORS of this file : DEMOTECH
class WattmeterTimeout(Exception):
    """
    When a timeout error occurs during the wattmeter execution
    """
    def __init__(self, message="A timeout occured during the wattmeter execution"):
        self.message = message
        super().__init__(self.message)