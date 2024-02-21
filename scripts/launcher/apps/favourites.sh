#!/bin/bash

# Set favourites, whitespace to increase width
FAVOURITES=()

HDMI_STATUS=$(xrandr | grep HDMI-0 | tr -s " " | cut -d ' ' -f 2)

if [ "$HDMI_STATUS" == "connected" ]
then
    ACTIVE_SINK=$(pactl info | grep "Default Sink" | tr -s " " | cut -d " " -f 3)

    if [ "$ACTIVE_SINK" = "alsa_output.pci-0000_00_1f.3.analog-stereo" ];
    then
        FAVOURITES=("Switch Audio to HDMI")
    else
        FAVOURITES=("Switch Audio to Internal")
    fi
fi

# Set favourites, whitespace to increase width
FAVOURITES+=(
"gpaste                                           "
"nautilus"
"vscode"
"spotify"
"firefox"
"joplin"
)

cmd=""
for fav in "${FAVOURITES[@]}"
do
   : 
   echo $fav
   cmd="${cmd}${fav}\n"
done


CMD=$(echo -e "$cmd" | dmenu -l 7 -h 30 -sb '#009777')

case "$CMD" in
"Switch Audio to HDMI")
    /home/ace/Developer/scripts/toggle/toggle_audio_output.sh
    ;;
"Switch Audio to Internal")
    /home/ace/Developer/scripts/toggle/toggle_audio_output.sh
    ;;
"gpaste                                           ")
    gpaste-client && gpaste-client ui
    ;;
"nautilus")
    i3-msg workspace 5:Nautilus
    nautilus
    ;;
"vscode")
    i3-msg workspace 3:VS Code
    code
    ;;
"spotify")
    i3-msg workspace 7:Spotify
    spotify
    ;;
"firefox")
    i3-msg workspace 2:Firefox
    firefox
    ;;
"joplin")
   /home/ace/AppImages/Joplin-2.3.5.AppImage &
    ;;
esac
