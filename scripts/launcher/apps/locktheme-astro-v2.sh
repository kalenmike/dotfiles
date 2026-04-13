#!/usr/bin/env bash

# ----------------
# A S T R O - V 2
# ---------------

# Scale = DPI / 96
SCALE=1.5

THEME=(
    --radius=$(echo "60 / $SCALE" | bc -l | xargs printf "%.0f")
    --ring-width=$(echo "6 / $SCALE" | bc -l | xargs printf "%.0f")
    --ind-pos=x+$(echo "2066 / $SCALE" | bc -l | xargs printf "%.0f"):y+$(echo "1874 / $SCALE" | bc -l | xargs printf "%.0f")
    --image=$HOME/Pictures/backgrounds/lockscreens/astro-v2.png
    --ring-color=ffffffff
    --ignore-empty-password
    --show-failed-attempts
    --screen=1
    --custom-key-commands
    --cmd-power-sleep="systemctl suspend"
    --line-color=00000000
    --ring-color=00000000
    --inside-color=00000000
    --insidever-color=00000000
    --insidewrong-color=00000000
    --ringver-color=C6A0F6FF
    --ringwrong-color=ED8796FF
    --verif-text=""
    --verif-color=00000000
    --wrong-text=""
    --wrong-color=00000000
    --keyhl-color=A6DA95FF
    --bshl-color=EED49FFF
)
