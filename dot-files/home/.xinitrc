[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
eval $(ssh-agent)
exec dunst &
exec dbus-launch --sh-syntax --exit-with-session i3
