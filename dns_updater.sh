#!/bin/bash

#Constants
EXTERNAL_IP_FILE=eip.tmp
LOG_FILE=ipchanges.log
SLEEP_TIME=1m
DNS_FILE=$1

#running forever
while [ 1 ]; do

	#Commands
DATE=$(date)
EXTERNAL_IP=$(curl ipecho.net/plain)
TEMP_EXTERNAL_IP=$(cat $EXTERNAL_IP_FILE)

IPADDRESS_STRING=$(cat <<EOF
		-- A Records
		a(_a, "$EXTERNAL_IP")

		-- CNAME Records
		cname("www", _a)

		-- MX Records
		mx(_a, _a)
EOF
)
	
	#TODO See if dns file exits 

	echo "Finding external ip..."
	echo "Founded external ip: $EXTERNAL_IP"

	if [ -e $EXTERNAL_IP_FILE ]
	then
		echo "$EXTERNAL_IP_FILE exits"
	else
		echo "0.0.0.0" > $EXTERNAL_IP_FILE
		echo "$EXTERNAL_IP_FILE created"
	fi

	echo "Previous IP: $TEMP_EXTERNAL_IP"

	if [ "$TEMP_EXTERNAL_IP" = "$EXTERNAL_IP" ]; then
		echo "IPs match"
	else
		echo "[$DATE: EXTERNAL_IP] $TEMP_EXTERNAL_IP to $EXTERNAL_IP" > $LOG_FILE
		echo $EXTERNAL_IP > $EXTERNAL_IP_FILE
		echo "IPs not match"
		echo $IPADDRESS_STRING > $1
		git commit -a -m "DNS updater"
		git push origin
	fi
	echo "-----------------------------------------"

	sleep $SLEEP_TIME
done