#!/usr/bin/env bash
# Script that fires on locking screen

# Define THEME
source ./locktheme-astro-v2.sh

# Set flags
IS_DESKTOP=1 # Set to 1 for desktop, 0 for laptop (default)

# Background Images
SAMSUNG_BG_IMAGE="$HOME/Pictures/backgrounds/lockscreen/bird-hacker.png"
SAMSUNG_TARGET_RES="1920x1080+2560+180"
LAPTOP_BG_IMAGE="$HOME/Pictures/backgrounds/lockscreen/bird-hacker.png"
BG_4K_IMAGE="$HOME/Pictures/backgrounds/lockscreen/astronaught.png"

# --- Calculating Coordinates --
# Coordinates are pixel center values, however your DPI scaling is applied.
# Assuming DPI of 144 would result in scaling of 1.5x (Standard DPI = 96)
# 144 / 96= 1.5
# So you need to divide your coordinates by the scaling factor

# --- Lockscreen Themes ---
ASTRO_V2=(
    --radius=38
    --ring-width=5
    --ind-pos=x+1377:y+1249
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

reset_ssh_keys() {
    # Remove SSH Keys in memory
    ssh-add -D
    # Tell polybar to update
    polybar-msg action ssh hook 0
}

# Check if HDMI is connected and if resolution matches the target
get_hdmi_status_and_resolution() {
    HDMI_STATUS=$(xrandr | grep HDMI-0 | tr -s " " | cut -d ' ' -f 2)
    ONBOARD_RES=$(xrandr | grep eDP-1-1 | tr -s " " | cut -d ' ' -f 3)
}

# Lock the screen with the appropriate background
lock_screen_with_background() {
    if [ "$IS_DESKTOP" -eq 1 ]; then
        # Desktop system, use 4K background image
        # -e ignore empty password, -t tile
        #i3lock -S 1 -i "$BG_4K_IMAGE" -e -f -t
        i3lock "${THEME[@]}"
    else
        # Check HDMI status and resolution for laptop
        get_hdmi_status_and_resolution

        if [ "$HDMI_STATUS" = "connected" ] && [ "$ONBOARD_RES" = "$SAMSUNG_TARGET_RES" ]; then
            # External monitor with target resolution
            i3lock -i "$SAMSUNG_BG_IMAGE" -e -f -t
        else
            # Laptop only, or HDMI with non-matching resolution
            i3lock -i "$LAPTOP_BG_IMAGE" -e -f -t
        fi
    fi
}

# Main execution
reset_ssh_keys
lock_screen_with_background
