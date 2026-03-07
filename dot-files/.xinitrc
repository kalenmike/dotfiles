#!/bin/sh

[ -f "$HOME/.Xresources" ] && xrdb -merge ~/.Xresources

eval "$(ssh-agent -s)"

# Wait 1s for 2 monitors, then run autorandr
sleep 1 && autorandr --change

dunst &
lxpolkit &

exec dbus-launch --sh-syntax --exit-with-session i3
