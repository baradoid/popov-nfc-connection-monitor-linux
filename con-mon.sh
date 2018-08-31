#!/bin/bash

timestamp() {
 date +"%T"
}


echo "$(timestamp) connection monitor"
omxplayer /home/rb/dev/connection-monitor/sounds/willBadGuy/starting.mp3 > /dev/null

IP='ya.ru'
counter=0


while true; do 
  wifiName=$( iwconfig 2>&1 | grep AP_smcd )
  if [ -z "$wifiName" ] ; then    
    if [ "$wifiStatusSayed" != "no wifi" ] ; then 		
      wifiStatusSayed="no wifi"	        
      counter=0
      echo "$(timestamp) no wifi"
    fi    
    
    if [ $counter -eq 0 ] ; then  
      counter=15
      omxplayer /home/rb/dev/connection-monitor/sounds/willBadGuy/no_wireless_connection.mp3 > /dev/null
    else
      counter=$((counter-1))
    fi
  else
    if [ "$wifiStatusSayed" != "wifi connected" ] ; then 		
      wifiStatusSayed="wifi connected"	  
      echo "$(timestamp) wifi connected"
      counter=0
      ipStatusSayed=""
      omxplayer /home/rb/dev/connection-monitor/sounds/willBadGuy/wifi_connection_established.mp3 > /dev/null
    fi    

    ping -q -c 1 ya.ru > /dev/null 2>/dev/null
    rc=$?
    if [ $rc -eq 0 ] ; then
      counter=0
      if [ "$ipStatusSayed" != "ping success" ] ; then 		
        ipStatusSayed="ping success"	      
        echo "$(timestamp) ping success"
        omxplayer /home/rb/dev/connection-monitor/sounds/willBadGuy/connection_success.mp3 > /dev/null        
      fi
    else
      if [ "$ipStatusSayed" != "ping failed" ] ; then
        ipStatusSayed="ping failed"
        echo "$(timestamp) ping fail"
      fi
      if [ $counter -eq 0 ] ; then  
        counter=10
        omxplayer /home/rb/dev/connection-monitor/sounds/willBadGuy/no_internet_connection.mp3 > /dev/null
      else
        counter=$((counter-1))
      fi
    fi
  fi
  sleep 1
done


