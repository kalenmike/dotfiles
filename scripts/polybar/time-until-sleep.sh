#!/usr/bin/env bash

# Get the current hour and minute
currentHour=$(date +%-H)
currentMinute=$(date +%-M)

# Target time is 23:00
targetHour=23
targetMinute=00

# Check if current time is after 19:00
if [ "$currentHour" -ge 19 ]; then
    # Calculate remaining time
    hoursLeft=$((targetHour - currentHour - 1))
    minutesLeft=$((60 - currentMinute))

    # Adjust hours and minutes
    if [ "$minutesLeft" -ge 60 ]; then
        hoursLeft=$((hoursLeft + 1))
        minutesLeft=$((minutesLeft - 60))
    fi

    # Print the time remaining
    echo "${hoursLeft}h ${minutesLeft}m"
fi

