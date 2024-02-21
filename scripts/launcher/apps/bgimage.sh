#!/usr/bin/env bash

IMAGE_ROOT="/home/ace/Pictures/backgrounds/time-pack"
# Set a randomized background folder
# feh --bg-scale --randomize /home/ace/Pictures/backgrounds/packs

# Function to get PIDs of running scripts
get_running_script_pids() {
  pgrep -f "launch-bgimage.sh" | grep -v $$
}

# Function to kill running scripts
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

randomize_image(){
    current_hour=$(date +"%H")
    current_hour_int=$(printf "%d" "${current_hour#0}")
    
    # Check the hour range and set the variable
    if (( current_hour_int > 12 && current_hour_int <= 18 )); then
        tod="afternoon"
    elif (( current_hour_int > 18 )) || (( current_hour_int < 6 )); then
        tod="night"
    else
        # 6 <= x <=12
        tod="morning"
    fi
                                                                         
    if [[ "$tod" != "$prev_tod" ]]; then
        echo "Switching to new time of day: $tod"
    fi
    image=$(ls $IMAGE_ROOT/$tod/* | grep -v "$prev_image" | shuf -n 1)
    echo $image > $IMAGE_ROOT/current_image
    echo "$prev_image -> $image"
    prev_image=$image
    feh --bg-scale $image
}

slideshow() {
    while true; do
        randomize_image
        sleep 600 # 10 minutes
    done
}


prev_image=" "
prev_tod=""
if [ "$1" == "now" ];then
    randomize_image
else
    kill_running_scripts # Kill running scripts before starting the new one
    slideshow &
fi

