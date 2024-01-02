[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
eval $(ssh-agent)
exec dunst &
exec lxpolkit &
exec dbus-launch --sh-syntax --exit-with-session i3
