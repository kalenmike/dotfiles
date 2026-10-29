#!/usr/bin/env bash

# --- Configuration ---
# You can use your .rasi variables here or hardcode hex codes
COLOR_TITLE="#FFFFFF"    # White
COLOR_INSTANCE="#9ca3af" # Grey
COLOR_EMPTY="#4b5563"    # Dark Grey
COLOR_SEP="#f38ba8"
SEPARATOR=" <span color='$COLOR_SEP'>󰇙</span> "

# --- Generator ---
# We build the list for Rofi
LIST=$(for i in {1..10}; do
    # Fetch windows for workspace $i
    # We use -r to get raw strings and handle the JSON tree recursively
    WINDOWS=$(i3-msg -t get_tree | jq -r "
        .. | select(.type? == \"workspace\" and .name == \"$i\") 
        | [ .. | select(.window_properties? != null) 
        | \"<span color='$COLOR_TITLE'>\(.window_properties.title | .[0:50] | @html)</span> <span color='$COLOR_INSTANCE'>(\(.window_properties.instance | @html))</span>\" ] 
        | join(\"$SEPARATOR\")
    ")

    if [ -z "$WINDOWS" ]; then
        echo -e "$i: <span color='$COLOR_EMPTY'>[ Empty ]</span>"
    else
        echo -e "$i: $WINDOWS"
    fi
done)

# --- Execution ---
# Pass the list to Rofi and capture the selection
# -markup-rows tells Rofi to render the <span> tags
CHOICE=$(echo -e "$LIST" | rofi -dmenu \
    -i \
    -markup-rows \
    -p "󱂬" \
    -theme "~/.config/rofi/themes/workspaces.rasi")

# --- Switching Logic ---
# If the user didn't hit Escape (CHOICE is not empty)
if [ -n "$CHOICE" ]; then
    # Extract everything before the first colon (the workspace number)
    WS_NUM=$(echo "$CHOICE" | cut -d':' -f1)

    # Tell i3 to switch
    i3-msg workspace "$WS_NUM"
fi
