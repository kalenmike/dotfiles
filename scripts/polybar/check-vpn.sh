#!/bin/bash
STATUS=$(nordvpn status | grep Status | tr -d ' ' | cut -d ':' -f 2)
IP_ADDR=$(nordvpn status | grep 'Server IP' | tr -d ' ' | cut -d ':' -f 2)

HIDE_IP=$1

#  ACTUAL_IP="207.188.142.161"

if [ "$STATUS" == "Connected" ];then
    ICON_ACTIVE="%{T9}%{F009777} 󰇧 %{F-}%{T-}"
    if [ "$HIDE_IP" == "hide" ];then
        echo "$ICON_ACTIVE"
    else
        echo "%{T1}$IP_ADDR $ICON_ACTIVE"
    fi
else
    echo "%{T9}%{FC33B23} 󰇨 %{F-}%{T-}"
fi
