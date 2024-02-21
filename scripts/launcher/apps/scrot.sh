#!/bin/bash
# sleep to give the giblib resource time (2/10 of a second) to load
sleep 0.2 ; scrot -s /home/ace/Pictures/screenshots/%Y-%m-%d-%H_%M_%S.png >> log.txt 2>&1

notify-send -i "null" "Scrot Info" "Window captured to /home/ace/Pictures/screenshots/" 
