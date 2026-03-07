#!/usr/bin/env bash
# Calculates the current phase of the moon

# Known new moon: 2000-01-06 (astronomical reference)
known_new_moon_jdn=2451550

date_to_jdn() {
    local y m d
    read y m d <<<"${1//-/ }"

    local a=$(( (14 - m) / 12 ))
    y=$(( y + 4800 - a ))
    m=$(( m + 12*a - 3 ))

    echo $(( d + (153*m + 2)/5 + 365*y + y/4 - y/100 + y/400 - 32045 ))
}

jdn=$(date_to_jdn "$(date +%F)")

# Days since known new moon
days=$(( jdn - known_new_moon_jdn ))

# Length of synodic month in scaled integers
# 29.530588 × 1000000
cycle=29530588

# Scale days into same unit
age=$(( (days * 1000000) % cycle ))

# Convert to phase index (0–7)
phase=$(( (age * 8) / cycle ))

case $phase in
    0) emoji="🌑" ;;
    1) emoji="🌒" ;;
    2) emoji="🌓" ;;
    3) emoji="🌔" ;;
    4) emoji="🌕" ;;
    5) emoji="🌖" ;;
    6) emoji="🌗" ;;
    7) emoji="🌘" ;;
esac

echo "$emoji"
