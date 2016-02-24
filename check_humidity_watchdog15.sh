#!/bin/bash

fflag=0
hostaddress=
community=

while getopts 'H:fC:c:w:' OPTION
do
	case $OPTION in
	H)	hostaddress="$OPTARG"
			;;
	C)	community="$OPTARG"
			;;
	c)	criticalrange="$OPTARG"
			;;
	w)	warningrange="$OPTARG"
			;;
	f)	fflag=1
			;;
	?)	printf "Usage: check_temp_weathergoose.sh -H <hostaddress> [-f] -w <warning> -c <critical>\n\n-H - The IP address of the Weathergoose\n-C - SNMP Community\n-f - Convert output to Fahrenheit\n-w - Warning Range\n-c - Critical Range"
			exit 3
			;;
	esac
done
shift $(($OPTIND - 1))
snmpcommand="snmpwalk -c ${community} -v 1 -O vq ${hostaddress} 1.3.6.1.4.1.17373.4.1.2.1.6" 
temp=`$snmpcommand`
if [ $fflag == 1 ]
	
	then temp=$((($temp))) 
fi

status=3

if [ "$criticalrange" != "" ]
	then
		criticallow=${criticalrange%%:*}
		criticalhigh=${criticalrange#*:}
	if [ "$criticallow" != "" ] && [ $temp -le "$criticallow" ]
		then
			if [ $fflag == 1 ]
				then
					echo "TEMP CRITICAL LOW - $temp F|'Temp (F)'=$temp;$warningrange;$criticalrange;30;120"
				else
					echo "TEMP CRITICAL LOW - $temp C|'Temp (C)'=$temp;$warningrange;$criticalrange;0;50"
			fi
			exit 2
	fi
	if [ "$criticalhigh" != "" ] && [ $temp -ge "$criticalhigh" ]
		then
			if [ $fflag == 1 ]
				then
					echo "TEMP CRITICAL HIGH - $temp F|'Temp (F)'=$temp;$warningrange;$criticalrange;30;120"
				else
					echo "TEMP CRITICAL HIGH - $temp C|'Temp (C)'=$temp;$warningrange;$criticalrange;0;50"
			fi
			exit 2
	fi
fi

if [ "$warningrange" != "" ]
	then
		warninglow=${warningrange%%:*}
		warninghigh=${warningrange#*:}
	if [ "$warninglow" != "" ] && [ $temp -le "$warninglow" ]
		then
			if [ $fflag == 1 ]
				then
					echo "TEMP LOW WARNING - $temp F|'Temp (F)'=$temp;$warningrange;$criticalrange;30;120"
				else
					echo "TEMP LOW WARNING - $temp C|'Temp (C)'=$temp;$warningrange;$criticalrange;0;50"
			fi
			exit 2
	fi
	if [ "$warninghigh" != "" ] && [ $temp -ge "$warninghigh" ]
		then
			if [ $fflag == 1 ]
				then
					echo "TEMP HIGH WARNING - $temp F|'Temp (F)'=$temp;$warningrange;$criticalrange;30;120"
				else
					echo "TEMP HIGH WARNING - $temp C|'Temp (C)'=$temp;$warningrange;$criticalrange;0;50"
			fi
			exit 2
	fi
fi
if [ $fflag == 1 ]
	then
		echo "TEMP OK - $temp F|'Temp (F)'=$temp;$warningrange;$criticalrange;30;120"
	else
		echo "TEMP OK - $temp C|'Temp (C)'=$temp;$warningrange;$criticalrange;0;50"
fi
exit 0
