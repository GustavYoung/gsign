#!/bin/bash
#Copyright 2017-2020 Gustavo Santana
#(C) 2017-2020 Mirai Works LLC
#Desactivamos el puto cursor >P
#setterm -cursor off

#set -x
sleep 0.2;
OMXPLAYER_DBUS_ADDR="/tmp/omxplayerdbus.${USER:-root}"
OMXPLAYER_DBUS_PID="/tmp/omxplayerdbus.${USER:-root}.pid"
export DBUS_SESSION_BUS_ADDRESS=`cat $OMXPLAYER_DBUS_ADDR`
export DBUS_SESSION_BUS_PID=`cat $OMXPLAYER_DBUS_PID`

ALPHA=1
    while [  $ALPHA -lt 256 ]; do
            dbus-send --print-reply=literal --session --dest=org.mpris.AdsPlayer2.omxplayer /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.SetAlpha objpath:/not/used int64:$ALPHA >/dev/null;
            let ALPHA=ALPHA+2
    done




