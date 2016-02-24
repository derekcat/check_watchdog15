#!/bin/bash
# Updated from bbrunning's version: 
# https://exchange.nagios.org/directory/Plugins/Hardware/Environmental/check_temp_watchdog15-%26-check_humidity_watchdog15/details
# By Derek DeMoss, for Dark Horse Comics, Inc. 2016
# Set all variables to caps, added option to set OID, fixed help to -h properly, commented a million things

HOSTADDRESS="1.2.3.4" # Initialized to junk
COMMUNITY="public" # Typical default
OID=".1.3.6.1.4.1.21239.5.1.2.1.6.1" # This is the default for the Dark Horse Watchdog's internal sensor

while getopts 'H:C:c:w:o:h' OPTION
do
        case $OPTION in
        H)      HOSTADDRESS="$OPTARG"
                        ;;
        C)      COMMUNITY="$OPTARG"
                        ;;
        c)      CRITICAL_RANGE="$OPTARG"
                        ;;
        w)      WARNING_RANGE="$OPTARG"
                        ;;
        o)      OID="$OPTARG"
                        ;;
        h)      printf "Usage: check_humid_weathergoose.sh -H <HOSTADDRESS> [-f] [-o <OID>] -w <warning range> -c <critical range>\n\n-H - The IP address of the Weathergoose\n-C - SNMP Community\n-f - Convert output to Fahrenheit\n-o - OID to override the default\n-w - Warning Range\n-c - Critical Range\nRanges should be : delimited, ex: 70:80\n"
                exit 3
                        ;;
        ?)      printf "Usage: check_humid_weathergoose.sh -H <HOSTADDRESS> [-f] [-o <OID>] -w <warning range> -c <critical range>\n\n-H - The IP address of the Weathergoose\n-C - SNMP Community\n-f - Convert output to Fahrenheit\n-o - OID to override the default\n-w - Warning Range\n-c - Critical Range\nRanges should be : delimited, ex: 70:80\n"
                exit 3
                        ;;
        esac
done

HUMID=`snmpget -c ${COMMUNITY} -v 1 -O vq ${HOSTADDRESS} $OID`

if [ "$CRITICAL_RANGE" != "" ]
        then
                CRITICAL_LOW=${CRITICAL_RANGE%%:*} # Grab the first half of CRITICAL_RANGE
                CRITICAL_HIGH=${CRITICAL_RANGE#*:} # Grab the second half of CRITICAL_RANGE
        if [ "$CRITICAL_LOW" != "" ] && [ $HUMID -le "$CRITICAL_LOW" ] # If the humidity is TOO low
                then
                        echo "HUMID CRITICAL LOW - $HUMID %|'Humidity (%)'=$HUMID;$WARNING_RANGE;$CRITICAL_RANGE;0;50"
                        exit 2
        fi
        if [ "$CRITICAL_HIGH" != "" ] && [ $HUMID -ge "$CRITICAL_HIGH" ] # If the humidity is TOO high
                then
                        echo "HUMID CRITICAL HIGH - $HUMID %|'Humidity (%)'=$HUMID;$WARNING_RANGE;$CRITICAL_RANGE;0;50"
                        exit 2
        fi
fi

if [ "$WARNING_RANGE" != "" ]
        then
                WARNING_LOW=${WARNING_RANGE%%:*} # Grab the first half of WARNING_RANGE
                WARNING_HIGH=${WARNING_RANGE#*:} # Grab the second half of WARNING_RANGE
        if [ "$WARNING_LOW" != "" ] && [ $HUMID -le "$WARNING_LOW" ] # If the humidity is TOO low
                then
                        echo "HUMID LOW WARNING - $HUMID %|'Humidity (%)'=$HUMID;$WARNING_RANGE;$CRITICAL_RANGE;0;50"
                        exit 1
        fi
        if [ "$WARNING_HIGH" != "" ] && [ $HUMID -ge "$WARNING_HIGH" ] # If the humidity is TOO high
                then
                        echo "HUMID HIGH WARNING - $HUMID %|'Humidity (%)'=$HUMID;$WARNING_RANGE;$CRITICAL_RANGE;0;50"
                        exit 1
        fi
fi

echo "HUMID OK - $HUMID %|'Humidity (%)'=$HUMID;$WARNING_RANGE;$CRITICAL_RANGE;30;120"
exit 0
