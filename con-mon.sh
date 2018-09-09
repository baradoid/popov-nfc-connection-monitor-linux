#!/bin/bash

timestamp() {
 date +"%T"
}


echo "$(timestamp) connection monitor"
omxplayer /home/rb/dev/connection-monitor/sounds/willBadGuy/starting.mp3 > /dev/null

#IP='ya.ru'
IP='T-2.primorye.net.ru'
counter=0
ipMsgCounter=0

while true; do 
  ping -q -c 1 ya.ru > /dev/null 2>/dev/null
  rc=$?
  if [ $rc -eq 0 ] ; then
    ipMsgCounter=0
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
    if [ $ipMsgCounter -eq 0 ] ; then  
      ipMsgCounter=10
      omxplayer /home/rb/dev/connection-monitor/sounds/willBadGuy/no_internet_connection.mp3 > /dev/null
    else
      ipMsgCounter=$((ipMsgCounter-1))
    fi

    wifiName=$( iwconfig 2>&1 | grep AP_smcd )
    if [ -z "$wifiName" ] ; then    
      if [ "$wifiStatusSayed" != "no wifi" ] ; then 		
        wifiStatusSayed="no wifi"	        
        wifiMsgCounter=0
        echo "$(timestamp) no wifi"
      fi    
      
      if [ $wifiMsgCounter -eq 0 ] ; then  
        wifiMsgCounter=15
        omxplayer /home/rb/dev/connection-monitor/sounds/willBadGuy/no_wireless_connection.mp3 > /dev/null
      else
        wifiMsgCounter=$((wifiMsgCounter-1))
      fi
    else
      if [ "$wifiStatusSayed" != "wifi connected" ] ; then 		
        wifiStatusSayed="wifi connected"	  
        echo "$(timestamp) wifi connected"
        wifiMsgCounter=0
        ipStatusSayed=""
        omxplayer /home/rb/dev/connection-monitor/sounds/willBadGuy/wifi_connection_established.mp3 > /dev/null
      fi    
    fi
  fi

  sleep 1
done


