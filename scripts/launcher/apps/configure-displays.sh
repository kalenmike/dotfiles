#!/usr/bin/env bash

# Date: 10/02/2023
# Author: Kalen Michael
# Configures the display in i3 depending on the connected monitors

# Get HDMI Connection status (connected | disconnected)
HDMI_STATUS=$(xrandr | grep HDMI-0 | tr -s " " | cut -d ' ' -f 2)

if [ "$HDMI_STATUS" == "connected" ]; then
    # HDMI is connected and the res is set to onboard only
    echo "External monitor connected. Applying dual monitor config..."
    # Apply config for my Samsung monitor on the left at 2k
    xrandr --dpi 100 --output HDMI-0 --primary --mode 2560x1440 --pos 0x0 --rotate normal --output eDP-1-1 --mode 1920x1080 --pos 2560x180 --rotate normal --output HDMI-1-1 --off
else
    # Enable all disabled displays with default config
    echo 'Unknown. Applying auto config...'
    xrandr --auto
fi

# Disable Screen blanking
xset -dpms     # disable standby for monitors
xset s noblank # disable turning the screen black
xset s off     # disable the x screensaver
