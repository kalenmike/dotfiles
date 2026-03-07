#!/usr/bin/env bash
# Launch picom transparency

# Add this to the top of picom.sh
killall -q picom
while pgrep -u $UID -x picom >/dev/null; do sleep 0.1; done
# Standard transparency
picom --config $HOME/.config/picom/config -b --no-fading-openclose

wait
