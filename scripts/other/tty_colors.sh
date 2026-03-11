#!/usr/bin/env bash

# This will manage your tty colors

COLOR_FILE="/home/jet/.tty_colors"

extract() {
    cat /sys/module/vt/parameters/default_red /sys/module/vt/parameters/default_grn /sys/module/vt/parameters/default_blu >$COLOR_FILE
}

apply() {
    sudo setvtrgb $COLOR_FILE
}

print_colors() {
    # Print a 16-color test pattern
    for i in {0..15}; do
        printf "\e[48;5;%sm  %02d  \e[0m" "$i" "$i"
        [ $(((i + 1) % 8)) -eq 0 ] && echo
    done
    echo
}

case "$1" in
extract)
    echo "Extracting current TTY colors to $COLOR_FILE..."
    extract
    echo "Done."
    ;;

apply)
    if [ -f "$COLOR_FILE" ]; then
        echo "Applying colors from $COLOR_FILE..."
        apply
        if [ $? -eq 0 ]; then
            echo "Colors applied."
        else
            echo "Error: Failed to apply colors."
            exit 1
        fi
    else
        echo "Error: $COLOR_FILE not found. Run 'extract' first."
        exit 1
    fi
    ;;

print)
    echo "Current color values in $COLOR_FILE:"
    print_colors
    ;;

*)
    echo "Usage: tty_colors [extract|apply|print]"
    exit 1
    ;;
esac
