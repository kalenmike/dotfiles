#!/usr/bin/env bash

###############################################################################
# Polybar Launch Script
#
# Behaviour:
# - If only one monitor is connected → primary bar on primary monitor
# - If multiple monitors:
#     - PRIMARY_MONITOR gets SECONDARY_BAR
#     - All other monitors get PRIMARY_BAR
#
# Arguments:
#   $1 → PRIMARY_BAR   (optional)
#   $2 → SECONDARY_BAR (optional)
#
# If not provided, defaults defined below are used.
# Bar Names are set in ~/.config/polybar/config
###############################################################################
#
# ---------------------------------------------------------------------------
# Kill existing Polybar instances
# ---------------------------------------------------------------------------
if ! killall -q polybar 2>/dev/null; then
    echo "No polybar processes found to kill"
fi

# Wait until polybar processes are fully terminated
while pgrep -u "$UID" -x polybar >/dev/null; do
    sleep 0.2
done

# Wait for i3
# ---------------------------------------------------------------------------
# Wait for i3 IPC socket to become available
# ---------------------------------------------------------------------------
echo "Waiting for i3 IPC socket..."
RETRY_COUNT=0
MAX_RETRIES=20

until i3-msg -t get_version >/dev/null 2>&1; do
    sleep 0.1
    RETRY_COUNT=$((RETRY_COUNT + 1))
    if [ $RETRY_COUNT -ge $MAX_RETRIES ]; then
        echo "⚠ Timeout: i3 socket not found after 2 seconds."
        exit 1
    fi
done
echo "i3 socket found. Proceeding with launch."

set -euo pipefail

# ---------------------------------------------------------------------------
# Defaults (can be overridden via CLI arguments)
# ---------------------------------------------------------------------------

PRIMARY_MONITOR="DP-0"

DEFAULT_PRIMARY_BAR="floating_primary"
DEFAULT_SECONDARY_BAR="floating_secondary"

PRIMARY_BAR="${1:-$DEFAULT_PRIMARY_BAR}"
SECONDARY_BAR="${2:-$DEFAULT_SECONDARY_BAR}"

# ---------------------------------------------------------------------------
# Monitor detection
# ---------------------------------------------------------------------------

if ! command -v xrandr >/dev/null 2>&1; then
    echo "xrandr not found — launching single bar."
    polybar --reload "$PRIMARY_BAR"
    exit 0
fi

mapfile -t MONITORS < <(xrandr --query | awk '/ connected/ {print $1}')
MONITOR_COUNT="${#MONITORS[@]}"

cat <<EOF
----------------------------------------
 MONITOR SETUP
----------------------------------------
 Count:    $MONITOR_COUNT (${MONITORS[*]})
 Primary:  $PRIMARY_MONITOR
 Bars:     $PRIMARY_BAR (Primary)
           $SECONDARY_BAR (Secondary)
----------------------------------------
EOF

# ---------------------------------------------------------------------------
# Launch bars per monitor
# ---------------------------------------------------------------------------

for MON in "${MONITORS[@]}"; do
    echo "Configuring monitor: $MON"

    if [[ "$MON" == "$PRIMARY_MONITOR" ]]; then
        if [[ "$MONITOR_COUNT" -eq 1 ]]; then
            echo "→ Single monitor setup. Launching PRIMARY_BAR."
            MONITOR="$MON" polybar --reload "$PRIMARY_BAR" &
        else
            echo "→ Multi-monitor setup. Launching SECONDARY_BAR on primary monitor."
            MONITOR="$MON" polybar --reload "$SECONDARY_BAR" &
        fi
    else
        echo "→ Launching PRIMARY_BAR."
        MONITOR="$MON" polybar --reload "$PRIMARY_BAR" &
    fi
done

wait
