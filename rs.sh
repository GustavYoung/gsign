#!/bin/bash
#Copyright 2017-2018 Gustavo Santana
#(C) 2017-2018 Mirai Works LLC
#Desactivamos el puto cursor >P
setterm -cursor off
sleep 1;
#set -x

#OMXPLAYER_DBUS_ADDR="/tmp/omxplayerdbus.${USER:-root}"
#OMXPLAYER_DBUS_PID="/tmp/omxplayerdbus.${USER:-root}.pid"
#export DBUS_SESSION_BUS_ADDRESS=`cat $OMXPLAYER_DBUS_ADDR`
#export DBUS_SESSION_BUS_PID=`cat $OMXPLAYER_DBUS_PID`

#Limpiamos la jodida pantalla?
#sudo sh -c “TERM=linux setterm -foreground black -clear >/dev/tty0”
TIMER="0";
TXSEC="$(($TIMER * 60))";

VIDEOPATH="/home/uslu/gsign/imgs/dia";

# Nombre de instancia para que no choque con la de uxmalstream
SERVICE="omxplayer2";

# infinite loop!
while true; do
        if ps ax | grep -v grep | grep $SERVICE > /dev/null
        then
        sleep 1;
else
        for entry in $VIDEOPATH/*
        do
	echo "start $entry" >> log_$(date +%Y_%m_%d).txt;
        echo "start $entry";
        # if [[ `lsof | grep /home/uslu/uxmalstream/streamer/uploads/ads/` ]]
        # then
        # sleep 1;
        # echo "espera por anuncio con audio" >> log_$(date +%Y_%m_%d).txt;
        # fi
	# if [[ `lsof | grep /home/uslu/uxmal_2.0/uploads/ads/` ]]
        # then
        # sleep 1;
        # echo "espera por anuncio con audio" >> log_$(date +%Y_%m_%d).txt;
        # fi
	# if [[ `lsof | grep /home/uslu/uxmalstream/uploads/sharedday/` ]]
        # then
        # sleep 1;
        # echo "espera por anuncio con audio" >> log_$(date +%Y_%m_%d).txt;
        # fi
        date >> log_$(date +%Y_%m_%d).txt;
	clear;
        ( cmdpid="$BASHPID";
        (omxplayer --genlog --vol -600 --layer 10 --alpha 1 --dbus_name org.mpris.AdsPlayer2.omxplayer "$entry" >> log_$(date +%Y_%m_%d).txt) \
        & while ! bash /home/uslu/gsign/fadein.sh;
        do
               echo "Todo listo";
               #exit;
        done
        wait)
	date >> log_$(date +%Y_%m_%d).txt;
	echo "Stop $entry" >> log_$(date +%Y_%m_%d).txt;
        echo "Stop $entry";
        clear;
	sleep $TXSEC;
        echo "." >> log_$(date +%Y_%m_%d).txt;
        done
fi
done
