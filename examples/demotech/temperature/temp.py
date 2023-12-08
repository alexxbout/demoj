#This program retrieve the CPU temperature
#of the raspberry pi under Raspberry OS

#open the file
f = open("/sys/class/thermal/thermal_zone0/temp", "r")

#convert the readed temperature to int 
temp = int(f.readline())

#print the value converted in Celsius degrees
print( temp/1000.0 ) 