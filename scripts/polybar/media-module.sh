#!/bin/bash

ACTION=$1

RESPONSE=""

if [ "$ACTION" == "display" ]; then
    if (($(playerctl -l 2>/dev/null | grep spotify | wc -l) >= 1)); then
        RESPONSE="$RESPONSE $(echo -n "%{F009777}%{T9} %{T1}%{F-} " && playerctl metadata -p spotify --format '{{artist}}: {{title}}')"
    elif (($(playerctl -l 2>/dev/null | grep firefox | wc -l) >= 1)); then
        RESPONSE="$RESPONSE$(echo -n "%{Fe07517}%{T9} %{T1}%{F-} " && playerctl metadata -p firefox --format '{{artist}}: {{title}}')"
    elif (($(playerctl -l 2>/dev/null | wc -l) >= 1)); then
        RESPONSE="$RESPONSE$(echo -n "%{Fc33b23}%{T9} %{T1}%{F-} " && playerctl metadata --format '{{xesam:title}}')"
    else
        RESPONSE="$RESPONSE$(echo -n "%{F009777}%{T9} %{T1}%{F-} Spotify")"
    fi

    echo "$RESPONSE"
else
    (playerctl play-pause -p spotify) || (playerctl play-pause -p firefox) || (playerctl play-pause) || (notify-send -i /home/ace/Developer/scripts/notifications/icons/spotify.png -a 'Spofity' 'Launching' 'Opening Spotify' && i3-msg workspace 6 && spotify &)
fi
