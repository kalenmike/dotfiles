#!/usr/bin/env bash
# Get the current bitcoin price every 60 seconds
# Keep a running average to deterimine the price direction
# https://publicapis.io/coin-gecko-api

MOVING_AVERAGE=10
SLEEP_SECONDS=60
# Define the script command
script_command="$HOME/Projects/linux/scripts/polybar/btc-price.sh"

# Get the current script's PID to exclude it from being killed
current_pid=$$

# Find and kill the processes matching the script command, excluding the current script
pgrep -f "$script_command" | grep -v "$current_pid" | xargs -r kill

get_bitcoin_price() {
    # Fetching Bitcoin data from CoinGecko API
    response=$(curl -s "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd")

    # Check if the response contains the expected data
    current_price=$(echo "$response" | jq -r '.bitcoin.usd' 2>/dev/null)

    # Check if the price is a valid number
    if [[ "$current_price" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        # Return the valid price
        echo "$current_price"
    else
        # If the price is not valid or the API call failed, return 0
        echo 0
    fi

    # Old code
    # if echo "$response" | jq -e '.bitcoin.usd' >/dev/null 2>&1; then
    #     echo $(echo "$response" | jq '.bitcoin.usd')
    # else
    #     echo 0
    # fi
}

get_bitcoin_price_last_24_hours() {
    # Fetching Bitcoin data from CoinGecko API
    response=$(curl -s "https://api.coingecko.com/api/v3/coins/bitcoin/market_chart?vs_currency=usd&days=1")
    if echo "$response" | jq -e '.prices' >/dev/null 2>&1; then
        echo $(echo "$response" | jq '.prices')
    else
        echo 0
    fi
}

prices=()

while true; do
    current_price=$(get_bitcoin_price)

    if [ "$current_price" -ne 0 ]; then
        # Add current price to the array
        prices=("${prices[@]}" "$current_price")

        # Keep only the last 10 prices
        if [ ${#prices[@]} -gt $MOVING_AVERAGE ]; then
            echo Reset the prices
            prices=("${prices[@]:1}")
        fi

        if [ ${#prices[@]} -ne 0 ]; then
            # Calculate the average of the last 10 prices
            total_price=0
            for price in "${prices[@]}"; do
                total_price=$(echo "$total_price + $price" | bc)
            done
            average_price=$(echo "scale=0; $total_price / ${#prices[@]}" | bc)

            # Compare with the previous price and print appropriate symbol
            if [ "$current_price" -gt "$average_price" ]; then
                symbol="↑"
            elif [ "$current_price" -lt "$average_price" ]; then
                symbol="↓"
            else
                symbol="→"
            fi

            echo "\$$(printf "%'.0f" $current_price) $symbol"
        fi
    else
        echo "Offline"
    fi

    sleep $SLEEP_SECONDS
done
