#!/usr/bin/env bash
# Date: 27/02/2026
# Author: Kalen Michael
# Execute app startup scripts and log output.
# Used with i3wm.

# # Kill any lingering subshells from a previous run.sh session
# This ensures we don't stack up processes every time we refresh i3.
trap "exit" INT TERM
_cur_pid=$$
for pid in $(pgrep -f "bash.*${0##*/}"); do
    if [ "$pid" != "$_cur_pid" ]; then
        kill "$pid" 2>/dev/null
    fi
done

LOCK_FILE="/tmp/i3_run_sh.lock"
if [ -f "$LOCK_FILE" ]; then
    PID=$(cat "$LOCK_FILE")
    if ps -p "$PID" >/dev/null; then
        log "[run.sh] Already running (PID $PID). Exiting."
        exit 1
    fi
fi
echo $$ >"$LOCK_FILE"

# Location of app startup scripts
SCRIPT_DIR="$(dirname "$0")/apps"
# Where to save the log file
LOG_FILE="$SCRIPT_DIR/../launch.log"
# App startup scripts to run
SCRIPTS=(
    "picom.sh"    # Transparency
    "bgimage.sh"  # Background image
    "bar.sh"      # Polybar
    "conky.sh"    # Show date on desktop
    "keyboard.sh" # Remap Keys
    "autotile.py" # Enable auto tiling
)

log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') $*" >>"$LOG_FILE"
}

# Keep only the last 1000 lines to prevent runaway file size
if [ -f "$LOG_FILE" ]; then
    tail -n 1000 "$LOG_FILE" >"$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"
fi

# Loop through execution array and log their execution
for script in "${SCRIPTS[@]}"; do
    # Run and log output
    log "[run.sh] Executing: $script"
    # while IFS= read -r line; do
    #     log "$line"
    # done < <("$SCRIPT_DIR/$script" 2>&1)
    {
        local_script="$script"

        "$SCRIPT_DIR/$local_script" 2>&1 | while IFS= read -r line; do
            # Ignore polybar notice logs
            if [[ ! "$line" =~ "Loaded font" ]] &&
                [[ ! "$line" =~ "Loading module" ]] &&
                [[ ! "$line" =~ "reconnect socket" ]] &&
                [[ ! "$line" =~ "Unexpected EOF" ]] &&
                [[ ! "$line" =~ "Failed to connect to i3" ]]; then
                log "[$script] $line"
            fi
        done

        # This part runs ONLY after the script exits
        STATUS=${PIPESTATUS[0]}

        # Log result
        if [ $STATUS -eq 0 ] || [ $STATUS -eq 143 ]; then
            log "[$local_script] Execution status: Success"
        else
            log "[$local_script] Execution status: ⚠ Failure (exit code $STATUS)"
        fi
    } &

done

log "[run.sh] Startup scripts loaded."
rm "$LOCK_FILE"
