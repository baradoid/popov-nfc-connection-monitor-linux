#!/bin/bash

timestamp() {
 date +"%T"
}


echo "$(timestamp) connection monitor"
omxplayer /home/rb/dev/connection-monitor/sounds/willBadGuy/starting.mp3 > /dev/null

statusSayed=""
IP='ya.ru'
UNREACHEABLE=1
counter=0


while true; do 
  ping -q -c 1 ya.ru > /dev/null 2>/dev/null
  rc=$?
if [ $rc -eq 0 ] ; then
counter=0
   if [ "$statusSayed" != "ping success" ] ; then 		
	echo "$(timestamp) ping success"
        omxplayer /home/rb/dev/connection-monitor/sounds/willBadGuy/connection_success.mp3 > /dev/null
	statusSayed="ping success"
   fi

    #
    #UNREACHEABLE=0;
else
   if [ "$statusSayed" != "ping failed" ] ; then
	statusSayed="ping failed"
	echo "$(timestamp) ping fail"
   fi

   if [ $counter -eq 0 ] ; then  
	counter=15
        omxplayer /home/rb/dev/connection-monitor/sounds/willBadGuy/no_connection.mp3 > /dev/null
   else
	counter=$((counter-1))
   fi
fi
  sleep 1
done


