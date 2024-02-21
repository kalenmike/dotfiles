#!/usr/bin/env bash
# Calculates the current phase of the moon

known_new_moon="2023-12-13"

current_date=$(date +%F)

# Convert date to Julian Day Number
date_to_jdn() {
    local date=$1
    local year=$(echo $date | cut -d '-' -f 1)
    local month=$(echo $date | cut -d '-' -f 2)
    local day=$(echo $date | cut -d '-' -f 3 | sed 's/^0*//')

    local a=$(( (14 - month) / 12 ))
    local y=$(( year + 4800 - a ))
    local m=$(( month + 12*a - 3 ))

    echo $(( day + (153*m+2)/5 + 365*y + y/4 - y/100 + y/400 - 32045 ))
}

# Calculate the Julian Day Number for known new moon and current date
jdn_new_moon=$(date_to_jdn $known_new_moon)
jdn_today=$(date_to_jdn $current_date)

# Calculate the difference in days
days_since_new_moon=$(( jdn_today - jdn_new_moon ))

# The lunar cycle is about 29.53 days
# Calculate the phase of the moon
phase_index=$(( days_since_new_moon % 29 ))

if [ "$1" == "--verbose" ]; then
    echo $phase_index
fi

# Determine the moon phase based on the phase index
if (( phase_index < 4 )); then
    phase_emoji="🌑" # New Moon
elif (( phase_index < 7 )); then
    phase_emoji="🌒" # Waxing Crescent
elif (( phase_index < 11 )); then
    phase_emoji="🌓" # First Quarter
elif (( phase_index < 15 )); then
    phase_emoji="🌔" # Waxing Gibbous
elif (( phase_index < 18 )); then
    phase_emoji="🌕" # Full Moon
elif (( phase_index < 22 )); then
    phase_emoji="🌖" # Waning Gibbous
elif (( phase_index < 26 )); then
    phase_emoji="🌗" # Last Quarter
else
    phase_emoji="🌘" # Waning Crescent
fi

# Output the phase emoji
echo "$phase_emoji"
