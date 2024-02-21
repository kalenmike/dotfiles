#/bin/bash
# Script that fires on locking screen

SAMSUNG_BG_IMAGE="/home/ace/Pictures/backgrounds/lockscreens/bird.png"
SAMSUNG_TARGET_RES="1920x1080+2560+180"

LAPTOP_BG_IMAGE="/home/ace/Pictures/backgrounds/pexels-fox-1172675.png"



# Get HDMI Connection status (connected | disconnected)
HDMI_STATUS=$(xrandr | grep HDMI-0 | tr -s " " | cut -d ' ' -f 2)

# Get HDMI Resolution mode
ONBOARD_RES=$(xrandr | grep eDP-1-1 | tr -s " " | cut -d ' ' -f 3)

# Remove SSH Keys in memory
ssh-add -D
# Tell polybar to update
polybar-msg action ssh hook 0

if [ "$HDMI_STATUS" = "connected" ] && [ "$ONBOARD_RES" = "$SAMSUNG_TARGET_RES" ]; then
   i3lock -i "$SAMSUNG_BG_IMAGE" -e -f -t
else
   i3lock -i "$LAPTOP_BG_IMAGE" -e -f -t
fi
