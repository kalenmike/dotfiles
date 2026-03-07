#/bin/bash
# Script that fires on locking screen

# Set flags
IS_DESKTOP=1 # Set to 1 for desktop, 0 for laptop (default)

# Background Images
SAMSUNG_BG_IMAGE="$HOME/Pictures/backgrounds/lockscreen/bird-hacker.png"
SAMSUNG_TARGET_RES="1920x1080+2560+180"
LAPTOP_BG_IMAGE="$HOME/Pictures/backgrounds/lockscreen/bird-hacker.png"
BG_4K_IMAGE="$HOME/Pictures/backgrounds/lockscreen/astronaught.png"

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
        i3lock -S 1 -i "$BG_4K_IMAGE" -e -f -t
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
