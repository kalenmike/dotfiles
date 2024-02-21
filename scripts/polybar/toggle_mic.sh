#!/bin/bash

#Toggle the microphone

ARGS=$1

STATE=$(amixer get Capture | tail -n 2 | tr -s " " | cut -d ' ' -f 8 | tr -d "\n")

if [ "$STATE" == "[off][off]" ]; then
    if [ "$ARGS" == "toggle" ]; then
        echo 'Microphone is muted.'
        amixer set Capture cap
    else
        echo "%{T3}%{FC33B23}%{F-}%{T-}"
    fi
else
    if [ "$ARGS" == "toggle" ]; then
        echo "Microphone is on. $STATE"
        amixer set Capture nocap
    else
        echo "%{T2}%{F009777}%{F-}%{T-}"
    fi
fi


