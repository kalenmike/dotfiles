#!/usr/bin/env bash

IMAGE_ROOT="$HOME/Pictures/backgrounds/time-pack/backgrounds_4k"
CURRENT_IMAGE=EMPTY
SLIDESHOW_SECONDS=600 # 10 minutes
SCRIPT_NAME=$(basename "$0")
VERBOSE=True

API_KEY=$(pass api/openweathermap | head -n 1)
LAT="39.4717207"
LON="-0.3594883"
ENDPOINT="https://api.openweathermap.org/data/2.5/weather"

# Set a randomized background folder
# feh --bg-scale --randomize /home/ace/Pictures/backgrounds/packs

get_running_script_pids() {
    pgrep -f $SCRIPT_NAME | grep -v $$
}

kill_running_scripts() {
    local pids=($(get_running_script_pids))
    if [[ ${#pids[@]} -gt 0 ]]; then
        echo -n "Killing running scripts..."
        kill "${pids[@]}" 2>/dev/null
        echo -n done.
        echo
    else
        echo "No running scripts found."
    fi
}

get_random_image() {
    local tod=$1
    local weather=$2
    echo $(fd -g "${weather}-${tod}-*.jpg" --type f --exclude "$CURRENT_IMAGE" "$IMAGE_ROOT" | shuf -n 1)
}

get_time_of_day() {
    local current_hour=$(date +"%H")
    local current_hour_int=$(printf "%d" "${current_hour#0}")

    # Check the hour range and set the variable
    if ((current_hour_int > 12 && current_hour_int <= 18)); then
        tod="mid"
    elif ((current_hour_int > 18)) || ((current_hour_int < 6)); then
        tod="lat"
    else
        # 6 <= x <=12
        tod="morn"
    fi

    echo $tod
}

set_vars() {
    # Make a request to OpenWeatherMap API
    DATA=$(curl -s "${ENDPOINT}?lat=${LAT}&lon=${LON}&appid=${API_KEY}&units=metric")

    # 2. Extract values using jq
    WEATHER_ID=$(echo "$DATA" | jq '.weather[0].id')
    SUNRISE=$(echo "$DATA" | jq '.sys.sunrise')
    SUNSET=$(echo "$DATA" | jq '.sys.sunset')
    NOW=$(echo "$DATA" | jq '.dt')

    # 3. Determine Time Segment
    if [ "$NOW" -lt "$SUNRISE" ] || [ "$NOW" -gt "$SUNSET" ]; then
        T="lat" # Night/Late
    elif [ "$NOW" -lt $((SUNRISE + 7200)) ]; then
        T="mor" # First 2 hours after sunrise
    else
        T="mid"
    fi

    # 4. Determine Weather Segment (based on OpenWeather IDs)
    # 2xx: Thunderstorm, 3xx: Drizzle, 5xx: Rain, 6xx: Snow, 7xx: Mist, 800: Clear, 80x: Clouds
    if [[ "$WEATHER_ID" -ge 200 && "$WEATHER_ID" -le 531 ]]; then
        W="rain"
    elif [[ "$WEATHER_ID" -eq 800 ]]; then
        W="sun"
    else
        W="cloud"
    fi
}

set_image() {
    set_vars
    CURRENT_IMAGE=$(get_random_image $T $W)
    feh --bg-scale $CURRENT_IMAGE
}

slideshow() {
    while true; do
        set_image
        sleep $SLIDESHOW_SECONDS
    done
}

if [ "$1" == "now" ]; then
    set_image
else
    kill_running_scripts # Kill running scripts before starting the new one
    slideshow >/dev/null 2>&1 &
    disown
    exit 0
fi
