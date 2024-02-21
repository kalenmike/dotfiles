#!/bin/bash

# Launch script for glava

# Kill all open bars
killall -q glava

# Mode (single (default)| dual)
MODE=$1

if [ "$MODE" == "dual" ]
then
    glava --desktop --force-mod=bars &
    glava --desktop --force-mod=bars_right --entry=hdmi.glsl &
else
    glava --desktop --force-mod=bars &
fi
