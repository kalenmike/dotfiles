#!/bin/bash


shutdown="󰐥"
reboot=""
lock=""
logout="󰗽"
suspend="⏾"

options="$suspend\n$lock\n$logout\n$reboot\n$shutdown"


rofi_command="rofi -theme /home/ace/.config/rofi/themes/powermenu.rasi"
chosen="$(echo -e "$options" | $rofi_command -dmenu -selected-row 0)"


case $chosen in
$suspend)
	/home/ace/Developer/scripts/launch/launch-i3lock.sh && systemctl suspend
	;;
$lock)
	/home/ace/Developer/scripts/launch/launch-i3lock.sh
	;;
$logout)
	i3-msg exit
	;;
$reboot)
	shutdown -r now
	;;
$shutdown)
	shutdown now
	;;
*)
	echo 'No Choice'
	;;
esac
