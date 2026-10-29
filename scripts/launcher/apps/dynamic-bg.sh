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


debug_msg() {
    if [ "$VERBOSE" = "True" ]; then
        echo "$@"
    fi
}

get_running_script_pids() {
    pgrep -f "$SCRIPT_NAME" | while read -r pid; do
        # Skip the current running instance
        if [ "$pid" -eq "$$" ]; then
            continue
        fi
        
        # Get the full command line for the process
        local cmd
        cmd=$(ps -p "$pid" -o args= 2>/dev/null)
        
        # Ignore if it's an editor, viewer, or grep command
        if [[ "$cmd" =~ (nvim|vim|nano|emacs|less|more|cat|grep) ]]; then
            continue
        fi
        
        echo "$pid"
    done
}

kill_running_scripts() {
    local pids=($(get_running_script_pids))
    debug_msg "Found: $pids"
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

    debug_msg "Time of day is: $tod"

    echo $tod
}

set_vars() {
    # Make a request to OpenWeatherMap API
    DATA=$(curl -s --connect-timeout 5 --max-time 10 "${ENDPOINT}?lat=${LAT}&lon=${LON}&appid=${API_KEY}&units=metric")

    # If curl failed or returned empty (no internet yet), use safe defaults
    if [ -z "$DATA" ] || ! echo "$DATA" | jq -e '.weather[0].id' >/dev/null 2>&1; then
        debug_msg "API request failed or timed out. Using fallback weather."
        T="mid"
        W="clear"
        return
    fi

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
        W="clear"
    else
        W="cloud"
    fi
}

set_image() {
    if [[ "$CURRENT_IMAGE" == "EMPTY" ]];then
        T=lat
        W=clear
    else
        set_vars
    fi
    debug_msg T: $T W: $W
    CURRENT_IMAGE=$(get_random_image $T $W)

    # If our targeted filter yielded nothing, grab *any* random image so we never boot to black
    if [ -z "$CURRENT_IMAGE" ] || [ ! -f "$CURRENT_IMAGE" ]; then
        debug_msg "Targeted image not found. Falling back to any random background."
        CURRENT_IMAGE=$(fd -g "*.jpg" --type f "$IMAGE_ROOT" | shuf -n 1)
    fi

    if [ -n "$CURRENT_IMAGE" ] && [ -f "$CURRENT_IMAGE" ]; then
        feh --bg-scale $CURRENT_IMAGE
        debug_msg "Set background to: $CURRENT_IMAGE"
    else
        debug_msg "No images found at all in $IMAGE_ROOT."
    fi
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
    debug_msg "Slideshow mode."
    kill_running_scripts # Kill running scripts before starting the new one
    if [ "$VERBOSE" = "True" ]; then 
        slideshow
    else
        slideshow >/dev/null 2>&1 &
        disown
        exit 0
    fi
    
fi
