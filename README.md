# check_watchdog15
My twist on a couple of Nagios check plugins used to monitor an ITWatchDogs/Geist Watchdog-15


Usage: check_temp_weathergoose.sh -H \<HOSTADDRESS\> [-f] [-o \<OID\>] -w \<warning range\> -c \<critical range\>

-H - The IP address of the Weathergoose

-C - SNMP Community

-f - Convert output to Fahrenheit

-o - OID to override the default

-w - Warning Range

-c - Critical Range

Ranges should be : delimited, ex: 70:80


Usage: check_humid_weathergoose.sh -H \<HOSTADDRESS\> [-f] [-o \<OID\>] -w \<warning range\> -c \<critical range\>

-H - The IP address of the Weathergoose

-C - SNMP Community

-o - OID to override the default

-w - Warning Range

-c - Critical Range

Ranges should be : delimited, ex: 70:80

