#!/usr/bin/env bash

# Show day of the week and date on desktop
killall conky
sleep 1
conky -c ~/.config/conky/date &
