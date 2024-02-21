#!/usr/bin/env bash

# Check if the current version of Bash supports associative arrays
if ((BASH_VERSINFO[0] < 4)); then
    echo "Bash version 4.0 or later is required."
    exit 1
fi

API_KEY="270dff9c0789023ae76bda49d5cd75d0"
LAT="39.4717207"
LON="-0.3594883"
ENDPOINT="http://api.openweathermap.org/data/2.5/weather"

# Make a request to OpenWeatherMap API
response=$(curl -s "${ENDPOINT}?lat=${LAT}&lon=${LON}&appid=${API_KEY}&units=metric")

# Parse and display the weather data
weather=$(echo $response | jq '.weather[0].main')
temperature=$(echo $response | jq '.main.temp')

# Extract sunrise and sunset times (Unix timestamp)
sunrise=$(echo $response | jq '.sys.sunrise')
sunset=$(echo $response | jq '.sys.sunset')

# Get current time in Unix timestamp
current_time=$(date +%s)

# Check if current time is within daylight hours
if [[ $current_time -ge $sunrise && $current_time -le $sunset ]]; then
    # Declare an associative array
    declare -A weather_to_emoji
    weather_to_emoji["Clear"]="☀️"
    weather_to_emoji["Clouds"]="⛅"
    weather_to_emoji["Rain"]="🌧️"
    weather_to_emoji["Snow"]="❄️"
    weather_to_emoji["Thunderstorm"]="⛈️"
    weather_to_emoji["Drizzle"]="💧"
    weather_to_emoji["Mist"]="🌧️"
    weather_to_emoji["Smoke"]="💨"
    weather_to_emoji["Haze"]="🌧️"
    weather_to_emoji["Dust"]="🌪️"
    weather_to_emoji["Fog"]="🌧️"
    weather_to_emoji["Sand"]="🏜️"
    weather_to_emoji["Ash"]="🌋"
    weather_to_emoji["Squall"]="💨"
    weather_to_emoji["Tornado"]="🌪️"
    
    # Get the emoji from the dictionary
    emoji=${weather_to_emoji["${weather//\"/}"]}
    
    # Check if emoji exists for the given condition
    if [ -n "$emoji" ]; then
        echo $emoji
    else
        echo "$weather"
    fi
else
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
    $script_dir/moonphase.sh
fi

#echo "Weather at ${LON},${LON}: ${weather}, Temperature: ${temperature}°C"
