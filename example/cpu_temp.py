# Authors :
# -  Olivier Palvadeau
# Description :
# Simply read the CPU themperature from a thermal_zone temperature file.
# Divide the result by 1000 in order to convert in Celsius.
# Most of the time Raspberry PIs only have one thermal_zone.

f = open("/sys/class/thermal/thermal_zone0/temp", "r")

temp = int(f.readline())

print("CPU temp", (temp/1000.0))

f.close()