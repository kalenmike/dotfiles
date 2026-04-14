#!/usr/bin/env bash

# Configuration
TEMPLATE_DIR="$HOME/Projects/linux/scripts/missions/templates"
LOG_DIR="$HOME/Neuronet/Capture/Missions"
MISSION_DIR="/tmp/active_missions"
STATE_FILE="$MISSION_DIR/state.json"

mkdir -p "$MISSION_DIR"
mkdir -p "$LOG_DIR"

# Helper: Format Seconds to Human Readable
format_time() {
    local s=$1
    if ((s < 60)); then
        echo "${s}s"
    elif ((s < 3600)); then
        echo "$((s / 60))m $((s % 60))s"
    elif ((s < 86400)); then
        echo "$((s / 3600))h $(((s % 3600) / 60))m"
    else
        echo "$((s / 86400))d $(((s % 86400) / 3600))h"
    fi
}

case "$1" in
--display)
    if [[ ! -f "$STATE_FILE" ]]; then
        echo "🚷 No Active Mission"
    else
        TITLE=$(grep -Po '(?<="title":")[^"]*' "$STATE_FILE")
        START=$(grep -Po '(?<="start":)[0-9]*' "$STATE_FILE")
        PAUSED=$(grep -Po '(?<="paused":)(true|false)' "$STATE_FILE")
        ACCUMULATED=$(grep -Po '(?<="accumulated_pause":)[0-9]*' "$STATE_FILE")
        NOW=$(date +%s)

        if [[ "$PAUSED" == "true" ]]; then
            PAUSE_START=$(grep -Po '(?<="pause_start":)[0-9]*' "$STATE_FILE")
            ELAPSED=$((PAUSE_START - START - ACCUMULATED))
            echo "⏸ $TITLE ($(format_time $ELAPSED))"
        else
            ELAPSED=$((NOW - START - ACCUMULATED))
            echo "🚀 $TITLE ($(format_time $ELAPSED))"
        fi
    fi
    ;;

--new)
    # If already started, just open for editing
    if [[ -f "$STATE_FILE" ]]; then
        FILE_PATH=$(grep -Po '(?<="file":")[^"]*' "$STATE_FILE")
        # Open and find the Title line (line starting with #)
        kitty --class=floatme -e nvim +/^# "$FILE_PATH"
        exit 0
    fi

    SELECTED=$(ls "$TEMPLATE_DIR" | rofi -dmenu -i -theme ~/Projects/linux/scripts/missions/rofi.rasi -p "🚀 Start a Mission")
    [[ -z "$SELECTED" ]] && exit 0

    # 1. Create a temporary work file
    TEMP_FILE="$MISSION_DIR/working_mission.md"
    START_HUMAN=$(date "+%Y-%m-%d %H:%M")
    UNIX_START=$(date +%s)

    # 3. Populate template into TEMP_FILE
    sed -e "s/{{start_timestamp}}/$START_HUMAN/g" \
        "$TEMPLATE_DIR/$SELECTED" >"$TEMP_FILE"

    # 4. Open nvim on the title line.
    # Check modification time before/after to see if user saved.
    OLD_MD5=$(md5sum "$TEMP_FILE")
    kitty --class=floatme -e nvim +/^# "$TEMP_FILE"
    NEW_MD5=$(md5sum "$TEMP_FILE")

    if [[ "$OLD_MD5" == "$NEW_ACC" ]] || [[ ! -s "$TEMP_FILE" ]]; then
        # User didn't save or file is empty
        rm -f "$TEMP_FILE"
        exit 0
    else
        # 5. User saved! Generate permanent filename and move
        DATE_STR=$(date +%F)
        COUNT=$(ls "$LOG_DIR"/${DATE_STR}_*.md 2>/dev/null | wc -l)
        NEXT_NUM=$((COUNT + 1))
        FINAL_PATH="$LOG_DIR/${DATE_STR}_${NEXT_NUM}.md"

        mv "$TEMP_FILE" "$FINAL_PATH"

        # 2. Extract Title from the Markdown (searching for the line starting with #)
        TITLE=$(grep -m 1 "^#" "$FINAL_PATH" | sed 's/^#\s*//')

        # Create State
        echo "{\"title\":\"$TITLE\", \"start\":$UNIX_START, \"file\":\"$FINAL_PATH\", \"paused\":false, \"accumulated_pause\":0}" >"$STATE_FILE"
    fi
    ;;

--pause)
    [[ ! -f "$STATE_FILE" ]] && exit 0
    PAUSED=$(grep -Po '(?<="paused":)(true|false)' "$STATE_FILE")

    if [[ "$PAUSED" == "false" ]]; then
        sed -i "s/\"paused\":false/\"paused\":true/" "$STATE_FILE"
        echo -e "$(cat "$STATE_FILE" | sed "s/}/, \"pause_start\":$(date +%s)}/")" >"$STATE_FILE"
    else
        NOW=$(date +%s)
        P_START=$(grep -Po '(?<="pause_start":)[0-9]*' "$STATE_FILE")
        ACC=$(grep -Po '(?<="accumulated_pause":)[0-9]*' "$STATE_FILE")
        DIFF=$((NOW - P_START))
        NEW_ACC=$((ACC + DIFF))

        sed -i "s/\"paused\":true/\"paused\":false/" "$STATE_FILE"
        sed -i "s/\"accumulated_pause\":$ACC/\"accumulated_pause\":$NEW_ACC/" "$STATE_FILE"
        sed -i "s/, \"pause_start\":[0-9]*//" "$STATE_FILE"
    fi
    ;;

--finish)
    [[ ! -f "$STATE_FILE" ]] && exit 0
    FILE=$(grep -Po '(?<="file":")[^"]*' "$STATE_FILE")
    ACC=$(grep -Po '(?<="accumulated_pause":)[0-9]*' "$STATE_FILE")

    END_HUMAN=$(date "+%Y-%m-%d %H:%M")

    # Update template tags
    sed -i "s/{{end_timestamp}}/$END_HUMAN/g" "$FILE"
    sed -i "s/{{total_pause_seconds}}/$(format_time $ACC)/g" "$FILE"

    # Open for final review
    kitty --class=floatme -e nvim +/^# "$FILE"

    rm "$STATE_FILE"
    ;;
esac
