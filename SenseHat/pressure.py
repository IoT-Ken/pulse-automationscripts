#!/usr/bin/python3
#############################################################################
# Filename: pressure.py
# Date Created: 03/18/19
# Date Modified: 
# Author: Ken Osborn 
#
# Version 1.0
#
# Description: Script returns pressure value to sensehat.sh so that Metric 
#              can be sent to Pulse.
#
# Usage: Place this script in /home/pi/scripts/sensehat and make it executable 
#        with chmod.  
#
# Version history:
# 1.0 - Ken Osborn: Script created.
#############################################################################
from sense_hat import SenseHat
sense = SenseHat()

pressure = 0
pressure = round(sense.get_pressure(),3)
print (pressure)