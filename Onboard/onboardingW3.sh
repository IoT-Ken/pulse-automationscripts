#!/bin/bash

echo "-----------------------------------------------------------------------------"
echo "---------------- WELCOME TO VMWARE PULSE 2.0 ONBOARDING TOOL ----------------"
echo "-----------------------------------------------------------------------------"
echo ""
echo ""
echo "NOTE: PRESS CTRL-C AT ANY TIME TO EXIT. MAKE SURE TO RUN CLEANUP.SH AFTER THAT"
echo ""
echo ""
# -------------------- BEGIN CHECK SCRIPT RUNNING AS ROOT --------------------

if [ "$EUID" -ne 0 ]
  then echo "Please run this script as Root"
  exit
fi

# -------------------- END CHECK SCRIPT RUNNING AS ROOT --------------------



# ------------- BEGIN TEST CONNECTION -------------
echo "STEP 1: TEST CONNECTION TO YOUR PULSE INSTANCE"
echo ""
echo "Enter your Pulse Console Instance (for example iotc001,iotc002, etc.): "
read PULSEINSTANCE;
PULSEADDENDUM="-pulse.vmware.com"
PULSEHOST="$PULSEINSTANCE$PULSEADDENDUM"
echo ""
echo "Testing Connection to https://$PULSEHOST..."
echo ""
echo "RESULTS:"

PULSEPORT=443
TIMEOUT=1

if nc -w $TIMEOUT -z $PULSEHOST $PULSEPORT; then
    echo "CONNECTION SUCCESSFUL!"
    echo "Connection to the Pulse Server ${PULSEHOST} was Successful"
else
    echo "CONNECTION FAILED!"
    echo "Connection to the Pulse Server ${PULSEHOST} Failed"
    echo "Please Confirm if the Pulse URL is correct"
    echo "If the Pulse URL is correct, then please ensure that we can open an outbound HTTPS connection to the Pulse Server over port 443"
    exit 1
fi

echo ""
echo ""
# ------------------ END TEST CONNECTION ------------------ "
# ------------------ BEGIN AGENT DOWNLOAD ------------------"

echo "STEP 2: SELECT THE AGENT YOU WANT TO DOWNLOAD"
echo ""
echo "Here's the result of the command uname -a:"
uname -a
echo ""
PULSEAGENTX86="/api/iotc-agent/iotc-agent-x86_64-2.0.0.501.tar.gz"
PULSEAGENTARM="/api/iotc-agent/iotc-agent-arm-2.0.0.501.tar.gz"
PULSEURLX86="https://$PULSEHOST$PULSEAGENTX86"
PULSEURLARM="https://$PULSEHOST$PULSEAGENTARM"

echo ""
echo "Based on the uname command result, select the agent below."
echo "If you don't have an agent in the list below, or if you want to exit, press any key other than 1 or 2"
echo "1): x86 Agent"
echo "2): ARM Agent"
echo ""
read AGENTSELECTION

while true; do
  # set the value of INPUT here
  if [ "$AGENTSELECTION" = "1" ]; then
    #echo "$PULSEURLX86"
    echo "Downloading the x86 agent from $PULSEHOST"
    mkdir /home/pulseagent
    curl -o /home/pulseagent/pulseagent.tar.gz $PULSEURLX86
    chmod -R 777 /home/pulseagent
  elif [ "$AGENTSELECTION" = "2" ]; then
    #echo "$PULSEURLARM"
    echo "Downloading the ARM agent from $PULSEHOST"
    mkdir /home/pulseagent
    curl -o /home/pulseagent/pulseagent.tar.gz $PULSEURLARM
    chmod -R 777 /home/pulseagent
  else
    echo "You have chosen an invalid option. This Script will exit now."
    exit 1
  fi
  break
done

echo ""
echo ""
echo "The Agent is downloaded at /home/pulseagent"
echo ""
# --------------------- END AGENT DOWNLOAD -----------------"
# -------------------- BEGIN AGENT UNTAR -------------------"

echo "STEP 3: UNZIPPING THE AGENT"
echo ""
tar -xzf /home/pulseagent/pulseagent.tar.gz -C /home/pulseagent
echo "The files are unzipped at /home/pulseagent/iotc-agent"
chmod -R 777 /home/pulseagent
echo ""

# -------------------- END AGENT UNTAR ---------------------"
# ------------------- BEGIN AGENT INSTALL ------------------"

echo "STEP 4: INSTALLING THE AGENT"

/home/pulseagent/iotc-agent/install.sh

echo ""
echo ""
echo "Installed the Agent"
echo "The Agent is installed at /opt/vmware/iotc-agent"
echo ""

# -------------------- END AGENT INSTALL -------------------"
# ------------------ BEGIN ONBOARDING GATEWAY ----------------------"

echo "STEP 5: LET'S ONBOARD THIS DEVICE TO YOUR PULSE CONSOLE: $PULSEHOST"
echo ""
echo "Please enter the device template name (Please make sure its a template name with no spaces):"
read PULSETEMPLATENAME
echo ""
echo "Please enter the device friendly name (Name that will show up once onboarded. No Spaces.): "
read PULSEGATEWAYNAME
echo ""
echo "Please enter your Pulse username (johndoe@acme.com): "
read PULSEUSERNAME
/opt/vmware/iotc-agent/bin/iotc-agent-cli enroll --template=$PULSETEMPLATENAME --name=$PULSEGATEWAYNAME --username=$PULSEUSERNAME --auth-type=BASIC
# ----------------------- END ONBOARDING GATEWAY ------------------------"
# ---------------------- BEGIN ONBOARDING A THING -----------------------"
echo "STEP 6: LET'S ONBOARD A THING TO THE GATEWAY"
echo ""
echo "Do you want to onboard a THING to your GATEWAY?"
echo "1 = Yes"
echo "2 = No"
read THINGINSTALL

#Acquire the DEVICEID of the GATEWAY
cat /opt/vmware/iotc-agent/data/data/deviceIds.data >device.id
PULSEDEVICEID=$(cat device.id)

while true; do
  # set the value of INPUT here
  if [ "$THINGINSTALL" = "1" ]; then
    #Start onboarding a THING to the GATEWAY
    echo ""
    echo "Ok. Let's collect some information about the THING ..."
    echo ""
    echo "Please enter the THING template name (Please make sure its a template name with no spaces):"
	read PULSETHINGTEMPLATENAME
	echo ""
	echo "Please enter the THING device friendly name (Name that will show up once onboarded. No Spaces.): "
	read PULSETHINGNAME
	echo ""
	echo "Onboard the THING to the GATEWAY now ..."
	/opt/vmware/iotc-agent/bin/DefaultClient enroll-device --template=$PULSETHINGTEMPLATENAME --name=$PULSETHINGNAME --parent-id=$PULSEDEVICEID
	
	RPIDEVICEID=$(cat -v /opt/vmware/iotc-agent/data/data/deviceIds.data | awk -F '^' '{print $1}' | awk -F '@' '{print $1}')
	SENSEHATDEVICEID=$(cat -v /opt/vmware/iotc-agent/data/data/deviceIds.data | awk -F '^' '{print $2}' | awk -F '@' '{print $2}')
	echo "GATEWAY ID:" $RPIDEVICEID "and THING ID:" $SENSEHATDEVICEID >/home/pi/pulseDeviceIDs
	echo ""
	echo "The device IDs are stored under /home/pi/pulseDeviceIDs"
	echo ""

  elif [ "$THINGINSTALL" = "2" ]; then
    #echo "$PULSEURLARM"
    echo "Skip the adding of a THING to the GATEWAY ..."
  else
    echo "You have chosen an invalid option. This Script will exit now."
    exit 1
  fi
  break
done
# ----------------------- END ONBOARDING A THING ------------------------"
# --------------------------- BEGIN METRICS -----------------------------"
# PULSEDEVICEID=$(cat /opt/vmware/iotc-agent/data/data/deviceIds.data)

#cat /opt/vmware/iotc-agent/data/data/deviceIds.data >device.id
#PULSEDEVICEID=$(cat device.id)

echo "STEP 6: LET'S START SENDING METRICS"
echo "Please enter the interval (in seconds) at which you want to send out CPU and Memory data:"
read PULSEMETRICSINTERVAL
/opt/vmware/iotc-agent/bin/DefaultClient start-daemon --device-id=$PULSEDEVICEID --interval=$PULSEMETRICSINTERVAL
echo ""
echo "Navigate to https://$PULSEHOST and confirm that the metrics are being published."
echo "Wait for a few minutes in case the metrics don't show up straight away."
echo "If the metrics don't show up, check the logs or run the DefaultClient Command manually."
echo ""
echo ""
echo "Thanks for onboarding the device to VMware Pulse IoT Center v2.0! Let your IoT Journey Begin!"
echo ""
echo "-----------------------------------------------------------------------------"
echo "-----------------------------------------------------------------------------"
echo "-----------------------------------------------------------------------------"

