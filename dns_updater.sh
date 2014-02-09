#!/bin/bash

#Constants
EXTERNAL_IP_FILE=eip.tmp
LOG_FILE=ipchanges.log
SLEEP_TIME=1m
DNS_FILE=$1


if [ -e $DNS_FILE ]
then
		echo "$DNS_FILE exits"
else
		echo "$DNS_FILE don't exits"
		echo "exiting..."
		exit
fi

#running forever
while [ 1 ]; do

#Commands
DATE=$(date)
EXTERNAL_IP=""

EXTERNAL_IP_1=$(curl ipecho.net/plain)
EXTERNAL_IP_2=$(curl ifconfig.me)

FOUNDED=0
	
echo "Finding external ip..."

for i in `seq 1 2`
do
	EXTERNAL_IP = EXTERNAL_IP_$i

	if [L_EXTERNAL_IP -ge 15 ]; then
		echo "Error getting EXTERNAL IP"	
	else		
		FOUNDED=1
		echo "Founded external ip: $EXTERNAL_IP"
	fi			
done

L_EXTERNAL_IP=$(echo "${#EXTERNAL_IP}")
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

	if [ $FOUNDED ]; then	

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
	fi
	sleep $SLEEP_TIME
done