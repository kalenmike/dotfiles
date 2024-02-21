#!/bin/bash

applications=("calc" "thunar" "obs" "gedit" )
icon_code="\0icon\x1f"

options=""
for app in "${applications[@]}"; do
    :
    options="$options$app$icon_code$app\n"
done

HDMI_STATUS=$(xrandr | grep HDMI-0 | tr -s " " | cut -d ' ' -f 2)

if [ "$HDMI_STATUS" == "connected" ]; then
    ACTIVE_SINK=$(pactl info | grep "Default Sink" | tr -s " " | cut -d " " -f 3)

    if [ "$ACTIVE_SINK" = "alsa_output.pci-0000_00_1f.3.analog-stereo" ]; then
        toggle_audio="toggle_audio\0icon\x1faudio-speakers"
        options="$options$toggle_audio"
    else
        toggle_audio="toggle_audio\0icon\x1flaptop-connected"
        options="$options$toggle_audio"
    fi
fi

rofi_command="rofi -theme /home/ace/.config/rofi/themes/favourite-apps-icons.rasi"
chosen="$(echo -e "$options" | $rofi_command -dmenu -selected-row 1)"

theme_path="/home/ace/.icons/Nordzy-yellow-dark/apps/scalable"

function launch_app() {
    APP=$1
    ICON=$2
    FRIENDLY=$3
    SINGLE=$4
    PROCESSES=$(pgrep $APP | wc -l)
    if [ "$SINGLE" == "true" ] && [ "$PROCESSES" == "0" ]; then
        notify-send "$FRIENDLY" 'Launching...' -u low -t 1200 --icon "$theme_path/$ICON.svg"
        $APP &
    elif [ "$SINGLE" == "true" ] && [ $PROCESSES -gt 0 ]; then
        notify-send "$FRIENDLY" 'Already running...' -u low -t 1200 --icon "$theme_path/$ICON.svg"
    elif [ "$SINGLE" == "false" ]; then
        notify-send "$FRIENDLY" 'Launching...' -u low -t 1200 --icon "$theme_path/$ICON.svg"
        $APP &
    fi
}

case $chosen in
"obs")
    i3-msg workspace 9
    /home/ace/scripts/litra-glow.sh on
    launch_app "obs --startvirtualcam" "obs" "Obs Studio" "true" &&
    /home/ace/scripts/litra-glow.sh off
    ;;
"brave")
    launch_app "brave-browser" "brave" "Brave" "true"
    i3-msg workspace 1
    ;;
"firefox")
    launch_app "firefox" "firefox" "Firefox" "true"
    i3-msg workspace 2
    ;;
"vscodium")
    launch_app "codium" "vscodium" "VSCodium" "false"
    i3-msg workspace 3
    ;;
"kitty")
    kitty -T floatme
    ;;
"thunar")
    launch_app "thunar" "thunar" "Thunar" "false"
    ;;
"spotify")
    launch_app "slack" "slack" "Slack" "true"
    i3-msg workspace 1
    ;;
"spotify")
    launch_app "spotify" "spotify" "Spotify" "true"
    i3-msg workspace 7
    ;;
"calc")
    launch_app "gnome-calculator" "calc" "Calculator" "false"
    ;;
"gnome-control-center")
    launch_app "gnome-control-center" "gnome-settings" "Control Center" "false"
    ;;
"gedit")
    launch_app "gedit" "gedit" "Notepad" "true"
    ;;
"postman")
    launch_app "postman" "postman" "Postman" "true"
    i3-msg workspace 10
    ;;
"toggle_audio")
    /home/ace/Projects/scripts/toggle/toggle_audio_output.sh
    ;;
*)
    echo 'No Choice'
    ;;
esac
