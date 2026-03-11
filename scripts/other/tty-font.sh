#!/usr/bin/env bash

FONT_DIR="/usr/share/consolefonts"

view_fonts() {
    # List files, remove the .psf.gz extension, and format nicely
    ls "$FONT_DIR" | sed 's/\.psf\.gz//' | column
}

test_font() {
    sudo setfont "$1" && echo "Font changed temporarily." || echo "Error: Font '$2' not found."
}

get_current_font() {
    grep -E "FONTFACE|FONTSIZE" /etc/default/console-setup || echo "No custom font configuration found in /etc/default/console-setup"
}

change_font() {
    echo Recomendations:
    echo Encoding: UTF-8
    echo Character Set: Combined - Latin Slavic Cyrillic Greek
    echo Font: Terminus or Fixed
    echo Size: 12x24
    read -n 1 -s -r -p "Press any key to continue..."
    sudo dpkg-reconfigure console-setup
}

restore_default() {
    setfont -d
}

case "$1" in
list)
    echo "Available console fonts:"
    view_fonts
    ;;

get)
    echo "Checking current font configuration..."
    get_current_font
    ;;

change)
    change_font
    ;;

restore)
    restore_default
    ;;

test)
    if [ -z "$2" ]; then
        echo "Error: Please specify a font name to test."
    else
        echo "Testing $2... (Press Ctrl+Alt+F7 or similar to return to X11 if needed)"
        test_font $2
    fi
    ;;

*)
    echo "Usage: tty-font [list|get|change|test|restore] <FontName>"
    exit 1
    ;;
esac
