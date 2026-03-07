#!/usr/bin/env bash
# Gets the first 20 lines of a command write up
# Used to display reminders on the desktop

# Path to your list of commands
COMMAND_FILE="$HOME/Documents/COMMANDS.txt"

CMD=$(grep -v '^[[:space:]]*#' "$COMMAND_FILE" | grep -v '^[[:space:]]*$' | shuf -n 1)

# Define your colors (Hex format)
COLOR_COMMENT="#bcc0cc"
COLOR_COMMAND="#dce0e8"
COLOR_TITLE="#179299"

# Fetch the cheat sheet
# We use 'sed' to wrap lines starting with # in comment colors
# and lines NOT starting with # in command colors.
RESPONSE=$(curl -s "https://cheat.sh/$CMD?T" | head -n 20 | sed \
    -e 's|\$|\\$|g' \
    -e "s|^\([[:space:]]*\)#\(.*\)$|\${color $COLOR_COMMENT}\1\\\#\2\${color}|" \
    -e "s|^\([[:space:]]*[^#].*\)$|\${color $COLOR_COMMAND}\1\${color}|")

echo -e "\${font FreeSans:size=12}\${color $COLOR_TITLE}$CMD\${color}\${font}\n\${hr}\n$RESPONSE"
