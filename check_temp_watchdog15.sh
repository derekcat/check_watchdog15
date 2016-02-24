#!/bin/bash
# Updated from bbrunning's version: 
# https://exchange.nagios.org/directory/Plugins/Hardware/Environmental/check_temp_watchdog15-%26-check_humidity_watchdog15/details
# By Derek DeMoss, for Dark Horse Comics, Inc. 2016
# Set all variables to caps, added option to set OID, fixed help to -h properly, commented a million things

FAHRENHEIT_FLAG=0 # Defaults to Celsius
HOSTADDRESS="1.2.3.4" # Initialized to junk
COMMUNITY="public" # Typical default
OID=".1.3.6.1.4.1.21239.5.1.2.1.5.1" # This is what bbrunning set it to for their Watchdog 15

while getopts 'H:fC:c:w:o:h' OPTION
do
	case $OPTION in
	H)	HOSTADDRESS="$OPTARG"
			;;
	C)	COMMUNITY="$OPTARG"
			;;
	c)	CRITICAL_RANGE="$OPTARG"
			;;
	w)	WARNING_RANGE="$OPTARG"
			;;
	o)	OID="$OPTARG"
			;;
	f)	FAHRENHEIT_FLAG=1
			;;
	h)	printf "Usage: check_temp_weathergoose.sh -H <HOSTADDRESS> [-f] [-o <OID>] -w <warning range> -c <critical range>\n\n-H - The IP address of the Weathergoose\n-C - SNMP Community\n-f - Convert output to Fahrenheit\n-o - OID to override the default\n-w - Warning Range\n-c - Critical Range\nRanges should be : delimited, ex: 70:80\n"
		exit 3
			;;
	?)	printf "Usage: check_temp_weathergoose.sh -H <HOSTADDRESS> [-f] [-o <OID>] -w <warning range> -c <critical range>\n\n-H - The IP address of the Weathergoose\n-C - SNMP Community\n-f - Convert output to Fahrenheit\n-o - OID to override the default\n-w - Warning Range\n-c - Critical Range\nRanges should be : delimited, ex: 70:80\n"
		exit 3
			;;
	esac
done

#shift $(($OPTIND - 1)) # I don't think we need this, as we won't check OPTIND again -Derek
TEMP=`snmpget -c ${COMMUNITY} -v 1 -O vq ${HOSTADDRESS} $OID`

if [ $FAHRENHEIT_FLAG == 1 ]
	then 
		TEMP=$((($TEMP/10))) # The Watchdog 15 outputs the temp as a multi hundred number, ex: 823
fi
#status=3 # What's this for?

if [ "$CRITICAL_RANGE" != "" ]
	then
		CRITICAL_LOW=${CRITICAL_RANGE%%:*} # Grab the first half of CRITICAL_RANGE
		CRITICAL_HIGH=${CRITICAL_RANGE#*:} # Grab the second half of CRITICAL_RANGE
	if [ "$CRITICAL_LOW" != "" ] && [ $TEMP -le "$CRITICAL_LOW" ] # If the temperature is TOO low
		then
			if [ $FAHRENHEIT_FLAG == 1 ]
				then
					echo "TEMP CRITICAL LOW - $TEMP F|'Temp (F)'=$TEMP;$WARNING_RANGE;$CRITICAL_RANGE;30;120"
				else
					echo "TEMP CRITICAL LOW - $TEMP C|'Temp (C)'=$TEMP;$WARNING_RANGE;$CRITICAL_RANGE;0;50"
			fi
			exit 2 
	fi
	if [ "$CRITICAL_HIGH" != "" ] && [ $TEMP -ge "$CRITICAL_HIGH" ] # If the temperature is TOO high
		then
			if [ $FAHRENHEIT_FLAG == 1 ]
				then
					echo "TEMP CRITICAL HIGH - $TEMP F|'Temp (F)'=$TEMP;$WARNING_RANGE;$CRITICAL_RANGE;30;120"
				else
					echo "TEMP CRITICAL HIGH - $TEMP C|'Temp (C)'=$TEMP;$WARNING_RANGE;$CRITICAL_RANGE;0;50"
			fi
			exit 2
	fi
fi

if [ "$WARNING_RANGE" != "" ]
	then
		WARNING_LOW=${WARNING_RANGE%%:*} # Grab the first half of WARNING_RANGE
		WARNING_HIGH=${WARNING_RANGE#*:} # Grab the second half of WARNING_RANGE
	if [ "$WARNING_LOW" != "" ] && [ $TEMP -le "$WARNING_LOW" ] # If the temperature is TOO low
		then
			if [ $FAHRENHEIT_FLAG == 1 ]
				then
					echo "TEMP LOW WARNING - $TEMP F|'Temp (F)'=$TEMP;$WARNING_RANGE;$CRITICAL_RANGE;30;120"
				else
					echo "TEMP LOW WARNING - $TEMP C|'Temp (C)'=$TEMP;$WARNING_RANGE;$CRITICAL_RANGE;0;50"
			fi
			exit 1
	fi
	if [ "$WARNING_HIGH" != "" ] && [ $TEMP -ge "$WARNING_HIGH" ] # If the temperature is TOO high
		then
			if [ $FAHRENHEIT_FLAG == 1 ]
				then
					echo "TEMP HIGH WARNING - $TEMP F|'Temp (F)'=$TEMP;$WARNING_RANGE;$CRITICAL_RANGE;30;120"
				else
					echo "TEMP HIGH WARNING - $TEMP C|'Temp (C)'=$TEMP;$WARNING_RANGE;$CRITICAL_RANGE;0;50"
			fi
			exit 1
	fi
fi

if [ $FAHRENHEIT_FLAG == 1 ]
	then
		echo "TEMP OK - $TEMP F|'Temp (F)'=$TEMP;$WARNING_RANGE;$CRITICAL_RANGE;30;120"
	else
		echo "TEMP OK - $TEMP C|'Temp (C)'=$TEMP;$WARNING_RANGE;$CRITICAL_RANGE;0;50"
fi
exit 0
