#!/usr/bin/env bash

# Get the battery info
BAT_INFO=$(acpi -b)

# Extract the time (format is HH:MM:SS)
TIME=$(echo "$BAT_INFO" | grep -o '[0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}' | cut -d: -f1,2)

# Check if we are charging or discharging
if echo "$BAT_INFO" | grep -q "Charging"; then
    echo "%{T10} %{T-} $TIME"
elif echo "$BAT_INFO" | grep -q "Discharging"; then
    echo "%{T10} %{T-} $TIME"
fi
