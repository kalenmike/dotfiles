#!/usr/bin/env bash
# Date: 21/02/2024
# Author: Kalen Michael
# Execute app startup scripts and log output.
# Used with i3wm.

# Location of app startup scripts
SCRIPT_DIR="$(dirname "$0")/apps"
# Where to save the log file
LOG_FILE="$SCRIPT_DIR/launch.log"
# App startup scripts to run
SCRIPTS=(
    "configure-displays.sh" # External Monitor
    "picom.sh"     # Transparency
    "bgimage.sh"     # Background image
    "polybar.sh"     # Menu Bar
    "conky.sh"       # Show date on desktop
    "keyboard.sh"          # Remap Keys
    "autotile.py"           # Enable auto tiling
)

# Wipe the log file
echo "" >$LOG_FILE

# Loop through execution array and log their execution
for script in "${SCRIPTS[@]}"; do
    echo "------------------------------------" >>$LOG_FILE
    echo "$(date) Executing $script" >>$LOG_FILE
    echo "------------------------------------" >>$LOG_FILE
    if $SCRIPT_DIR/$script >>$LOG_FILE 2>&1; then
        echo "Execution status: Success" $LOG_FILE
    else
        echo "Execution status: Error" >>$LOG_FILE
    fi
    echo -e "------------------------------------\n" >>$LOG_FILE
done

# Summary
echo "=====================================" >>"$LOG_FILE"
echo "Execution completed: $(date)" >>$LOG_FILE
