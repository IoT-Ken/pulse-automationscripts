#!/usr/bin/python3
from sense_hat import SenseHat
sense = SenseHat()

sensetemp = 0
sensetemp = round(sense.get_temperature(),3)
# Convert to Fahrenheit and account for case heat
sensetemp = ( ((sensetemp/5*9)+32)-26 )
print (sensetemp)
