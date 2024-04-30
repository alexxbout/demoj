def getCPUtemperature():
    f = open("/sys/class/thermal/thermal_zone0/temp", "r")
    temp = int(f.readline())
    f.close()
    return temp / 1000.0
