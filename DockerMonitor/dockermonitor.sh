#!/bin/bash
#############################################################################
# Filename: dockermonitor.sh
# Date Created: 03/19/19
# Date Modified: 
# Author: Parth and Ken
#
# Version 1.0
#
# Description: Script called by the docker monitor service to gather
#              container information and report properties and metrics to
#              pulse console.
#
# Usage: Place this script in /home/pi/scripts/dockermonitor and make it 
#        executable with chmod.  Gateway and Thing (SenseHat) need to be 
#        enrolled on Pulse in order for this to function.  Thing can be 
#        enrolled utilizing:
#        ./iotc-agent-cli enroll --device-id=<device Id> --parent-id=<parent Id>
#
# Version history:
# 1.0 - Parth and Ken: First version of the script.
#############################################################################

#Declare Container Variables
ROMANTIC_HERTZ=$(cat -v /opt/vmware/iotc-agent/data/data/deviceIds.data | awk -F '^' '{print $3}' | awk -F '@' '{print $2}')
YOUTHFUL_BHABHA=$(cat -v /opt/vmware/iotc-agent/data/data/deviceIds.data | awk -F '^' '{print $4}' | awk -F '@' '{print $2}')
EAGER_NEUMANN=$(cat -v /opt/vmware/iotc-agent/data/data/deviceIds.data | awk -F '^' '{print $5}' | awk -F '@' '{print $2}')

#Declare Gateway Variable(s)
RPIDEVICEID=$(cat -v /opt/vmware/iotc-agent/data/data/deviceIds.data | awk -F '^' '{print $1}' | awk -F '@' '{print $1}')

#Get Docker Container ID - Thing System Property
DCID1=$(docker ps -aq | awk 'BEGIN{ RS = "" ; FS = "\n" }{print $1}')
DCID2=$(docker ps -aq | awk 'BEGIN{ RS = "" ; FS = "\n" }{print $2}')
DCID3=$(docker ps -aq | awk 'BEGIN{ RS = "" ; FS = "\n" }{print $3}')
#DCID4=$(docker ps -aq | awk 'BEGIN{ RS = "" ; FS = "\n" }{print $4}')
#DCID5=$(docker ps -aq | awk 'BEGIN{ RS = "" ; FS = "\n" }{print $5}')
sudo /opt/vmware/iotc-agent/bin/iotc-agent-cli send-properties --device-id=$ROMANTIC_HERTZ --key=ContainerID --value=$DCID1
sudo /opt/vmware/iotc-agent/bin/iotc-agent-cli send-properties --device-id=$YOUTHFUL_BHABHA --key=ContainerID --value=$DCID2
sudo /opt/vmware/iotc-agent/bin/iotc-agent-cli send-properties --device-id=$EAGER_NEUMANN --key=ContainerID --value=$DCID3

#Get Docker Container Name - Thing System Property
DCNAME1=$(docker inspect --format='{{.Name}}' $DCID1 | awk -F '/' '{print $2}')
DCNAME2=$(docker inspect --format='{{.Name}}' $DCID2 | awk -F '/' '{print $2}')
DCNAME3=$(docker inspect --format='{{.Name}}' $DCID3 | awk -F '/' '{print $2}')
#DCNAME4=$(docker inspect --format='{{.Name}}' $DCID4 | awk -F '/' '{print $2}')
#DCNAME5=$(docker inspect --format='{{.Name}}' $DCID5 | awk -F '/' '{print $2}')
sudo /opt/vmware/iotc-agent/bin/iotc-agent-cli send-properties --device-id=$ROMANTIC_HERTZ --key=ContainerName --value=$DCNAME1
sudo /opt/vmware/iotc-agent/bin/iotc-agent-cli send-properties --device-id=$YOUTHFUL_BHABHA --key=ContainerName --value=$DCNAME2
sudo /opt/vmware/iotc-agent/bin/iotc-agent-cli send-properties --device-id=$EAGER_NEUMANN --key=ContainerName --value=$DCNAME3

#Get Docker Container State - Thing Metrics
DCSTATE1=$(docker inspect --format='{{.State.Running}}' $DCID1)
DCSTATE2=$(docker inspect --format='{{.State.Running}}' $DCID2)
DCSTATE3=$(docker inspect --format='{{.State.Running}}' $DCID3)
#DCSTATE4=$(docker inspect --format='{{.State.Running}}' $DCID4)
#DCSTATE5=$(docker inspect --format='{{.State.Running}}' $DCID5)
sudo /opt/vmware/iotc-agent/bin/iotc-agent-cli send-metric --device-id=$ROMANTIC_HERTZ --name=ContainerState --type=boolean --value=$DCSTATE1
sudo /opt/vmware/iotc-agent/bin/iotc-agent-cli send-metric --device-id=$YOUTHFUL_BHABHA --name=ContainerState --type=boolean --value=$DCSTATE2
sudo /opt/vmware/iotc-agent/bin/iotc-agent-cli send-metric --device-id=$EAGER_NEUMANN --name=ContainerState --type=boolean --value=$DCSTATE3

#Get Docker Container Status - Thing System Property
DCSTATUS1=$(docker inspect --format='{{.State.Status}}' $DCID1)
DCSTATUS2=$(docker inspect --format='{{.State.Status}}' $DCID2)
DCSTATUS3=$(docker inspect --format='{{.State.Status}}' $DCID3)
#DCSTATUS4=$(docker inspect --format='{{.State.Status}}' $DCID4)
#DCSTATUS5=$(docker inspect --format='{{.State.Status}}' $DCID5)
sudo /opt/vmware/iotc-agent/bin/iotc-agent-cli send-properties --device-id=$ROMANTIC_HERTZ --key=ContainerStatus --value=$DCSTATUS1
sudo /opt/vmware/iotc-agent/bin/iotc-agent-cli send-properties --device-id=$YOUTHFUL_BHABHA --key=ContainerStatus --value=$DCSTATUS2
sudo /opt/vmware/iotc-agent/bin/iotc-agent-cli send-properties --device-id=$EAGER_NEUMANN --key=ContainerStatus --value=$DCSTATUS3

#Get Docker Container PID - Thing System Property
DCPID1=$(docker inspect --format='{{.State.Pid}}' $DCID1)
DCPID2=$(docker inspect --format='{{.State.Pid}}' $DCID2)
DCPID3=$(docker inspect --format='{{.State.Pid}}' $DCID3)
#DCPID4=$(docker inspect --format='{{.State.Pid}}' $DCID4)
#DCPID5=$(docker inspect --format='{{.State.Pid}}' $DCID5)
sudo /opt/vmware/iotc-agent/bin/iotc-agent-cli send-properties --device-id=$ROMANTIC_HERTZ --key=ContainerPid --value=$DCPID1
sudo /opt/vmware/iotc-agent/bin/iotc-agent-cli send-properties --device-id=$YOUTHFUL_BHABHA --key=ContainerPid --value=$DCPID2
sudo /opt/vmware/iotc-agent/bin/iotc-agent-cli send-properties --device-id=$EAGER_NEUMANN --key=ContainerPid --value=$DCPID3

#Get Docker Image ID - Thing System Property
DCIID1=$(docker inspect --format='{{.Image}}' $DCID1 | awk -F ':' '{print $2}' | awk '{print substr($0,0,10)}')
DCIID2=$(docker inspect --format='{{.Image}}' $DCID2 | awk -F ':' '{print $2}' | awk '{print substr($0,0,10)}') 
DCIID3=$(docker inspect --format='{{.Image}}' $DCID3 | awk -F ':' '{print $2}' | awk '{print substr($0,0,10)}')
#DCIID4=$(docker inspect --format='{{.Config.Image}}' $DCID4)
#DCIID5=$(docker inspect --format='{{.Config.Image}}' $DCID5)
sudo /opt/vmware/iotc-agent/bin/iotc-agent-cli send-properties --device-id=$ROMANTIC_HERTZ --key=ImageID --value=$DCIID1
sudo /opt/vmware/iotc-agent/bin/iotc-agent-cli send-properties --device-id=$YOUTHFUL_BHABHA --key=ImageID --value=$DCIID2
sudo /opt/vmware/iotc-agent/bin/iotc-agent-cli send-properties --device-id=$EAGER_NEUMANN --key=ImageID --value=$DCIID3

#Get Docker Image Name - Thing System Property
DCINAME1=$(docker images --no-trunc | grep $DCIID1 | awk '{print $1}')
DCINAME2=$(docker images --no-trunc | grep $DCIID2 | awk '{print $1}')
DCINAME3=$(docker images --no-trunc | grep $DCIID3 | awk '{print $1}')
#DCINAME4=$(docker images | grep $DCIID4 | awk '{print $2}')
#DCINAME5=$(docker images | grep $DCIID5 | awk '{print $2}')
sudo /opt/vmware/iotc-agent/bin/iotc-agent-cli send-properties --device-id=$ROMANTIC_HERTZ --key=ImageName --value=$DCINAME1
sudo /opt/vmware/iotc-agent/bin/iotc-agent-cli send-properties --device-id=$YOUTHFUL_BHABHA --key=ImageName --value=$DCINAME2
sudo /opt/vmware/iotc-agent/bin/iotc-agent-cli send-properties --device-id=$EAGER_NEUMANN --key=ImageName --value=$DCINAME3

#Get Count of Total Containers - Gateway Metric and System Property
DCCOUNT=$(docker ps -aq $1 | wc -l)
sudo /opt/vmware/iotc-agent/bin/iotc-agent-cli send-properties --device-id=$RPIDEVICEID --key=container-count --value=$DCCOUNT

# Configure Collection Interval
sleep 30