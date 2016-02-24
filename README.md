# check_watchdog15
My twist on a couple of Nagios check plugins used to monitor an ITWatchDogs/Geist Watchdog-15

This confused me at first, so I'd like to say FYI: The first number of the range is the low threshold before going into a warning/critical state, whereas the second number is the upper threshold before hitting a state.  This enables you to have an alert if the temperature or humidity goes *either* too high or too low.

If you access the web interface for your Watchdog 15, you should be able to download the MIBs, which also include a spreadsheet for the OID references.  Use this, but prepend a period, and append a .1 to the spreadsheet's OIDs when passing to these scripts.  (See the defaults in the checks for an example)  This is a small side effect of using snmpget instead of snmpwalk.  snmpwalk will print both the value of the requested OID, and *occasionally* "End of MIB", which of course breaks the script...  This could've been resolved by using a grep -v "End of MIB" | snmpwalk, but I believe that is less efficient than just snmpget.


Usage: check_temp_weathergoose.sh -H \<HOSTADDRESS\> [-f] [-o \<OID\>] -w \<warning range\> -c \<critical range\>

-H - The IP address of the Weathergoose

-C - SNMP Community

-f - Convert output to Fahrenheit

-o - OID to override the default

-w - Warning Range

-c - Critical Range

Ranges should be : delimited, ex: 40:80



Usage: check_humid_weathergoose.sh -H \<HOSTADDRESS\> [-f] [-o \<OID\>] -w \<warning range\> -c \<critical range\>

-H - The IP address of the Weathergoose

-C - SNMP Community

-o - OID to override the default

-w - Warning Range

-c - Critical Range

Ranges should be : delimited, ex: 0:60

