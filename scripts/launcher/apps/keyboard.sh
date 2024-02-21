#!/bin/bash
# Change the default keyboard layout
# Reset with setxkbmap
# Get keycode with  xev | grep -A5 KeyPress
# Normal Shift Lock Control ALT_L NUM_LOCK Mod3 SUPER ALT_GR

# Add tilde to backslack
xmodmap -e "keycode 49 = asciitilde backslash"

# Swap Alt + 3 for Shift + 3 = #
xmodmap -e "keycode 12 = 3 numbersign NoSymbol NoSymbol periodcentered"

# Make { Default
xmodmap -e "keycode 48 = braceleft NoSymbol NoSymbol NoSymbol dead_acute"

# Make } Default
xmodmap -e "keycode 51 = braceright NoSymbol NoSymbol NoSymbol ccedilla"
