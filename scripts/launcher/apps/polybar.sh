#!/bin/bash

# Launch script for polybar
# When mobile show only primary
# When docked switch primary to external monitor

# Kill all open bars
killall -q polybar

# Monitor Names
PRIMARY_MONITOR="eDP-1-1"

# Bar Names - set in ~/.config/polybar/config
PRIMARY_BAR=bar_primary
SECONDARY_BAR=bar_secondary

if type "xrandr" > /dev/null 2>&1; then
    CONNECTED_MONITORS=$(xrandr --query | grep " connected")
    MONITOR_COUNT=$( echo "$CONNECTED_MONITORS" | wc -l)
    echo "$CONNECTED_MONITORS" | cut -d " " -f1 | while read m; do
        echo $m
        if [ "$m" = "$PRIMARY_MONITOR" ]; then
            if [ "$MONITOR_COUNT" -eq 1 ];then
                # No monitor is connected set onboard as primary
                MONITOR=$m polybar --reload $PRIMARY_BAR &
            else
                # Monitor is connected set onboard as secondary
                MONITOR=$m polybar --reload $SECONDARY_BAR &
            fi
        else
            MONITOR=$m polybar --reload $PRIMARY_BAR &
        fi
    done
else
    polybar --reload $PRIMARY_BAR &
fi
