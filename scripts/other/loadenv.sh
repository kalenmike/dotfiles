#!/usr/bin/env bash

# Usage: 
# . loadenv production  <- Load secrets
# . loadenv             <- Check status
# . loadenv unset       <- Clear secrets

PROJECT_NAME=$(basename "$PWD")
ENV_ARG=$1

# --- 1. THE UNSET/CLEAR LOGIC ---
if [ "$ENV_ARG" = "unset" ] || [ "$ENV_ARG" = "clear" ]; then
    if [ -z "$CURRENT_ENV_ACTIVE" ]; then
        echo "No environment is currently loaded."
        return 0
    fi

    # Retrieve the secrets one last time to find the keys we need to unset
    PASS_PATH="env/$PROJECT_NAME/$CURRENT_ENV_ACTIVE"
    keys=$(pass show "$PASS_PATH" 2>/dev/null | cut -d'=' -f1)

    for key in $keys; do
        if [[ "$key" =~ ^[A-Za-z0-9_]+$ ]]; then
            unset "$key"
        fi
    done

    echo "Unloaded environment: [$CURRENT_ENV_ACTIVE]"
    unset CURRENT_ENV_ACTIVE
    exit 0
fi

# --- 2. THE STATUS CHECK (No Args) ---
if [ -z "$ENV_ARG" ]; then
    if [ -z "$CURRENT_ENV_ACTIVE" ]; then
        echo "No environment currently loaded for $PROJECT_NAME."
    else
        echo -e "Active Environment: [\e[38;5;110m$CURRENT_ENV_ACTIVE\e[0m]"
    fi
    exit 0
fi


# Checks if the script is being executed rather than sourced
if [[ "$0" == "${BASH_SOURCE[0]}" || "$0" == "$BASH_ARGV0" ]]; then
    echo "Error: This script must be sourced to modify your environment."
    echo "Usage: . loadenv $1 (Note the dot at the beginning)"
    exit 1
fi

# --- 3. THE LOADING LOGIC ---
PASS_PATH="env/$PROJECT_NAME/$ENV_ARG"

if secrets=$(pass show "$PASS_PATH" 2>/dev/null); then
    # If switching envs, unset the old one first to avoid ghost variables
    if [ -n "$CURRENT_ENV_ACTIVE" ] && [ "$CURRENT_ENV_ACTIVE" != "$ENV_ARG" ]; then
        . loadenv unset > /dev/null
    fi

    echo "Loading $ENV_ARG secrets for $PROJECT_NAME..."
    
    # Parse and Export
    while IFS= read -r line; do
        # Ignore empty lines or comments
        [[ -z "$line" || "$line" =~ ^# ]] && continue
        
        # Ensure it's a valid KEY=VALUE pair
        if [[ "$line" =~ ^[A-Za-z0-9_]+= ]]; then
            export "$line"
        fi
    done <<< "$secrets"

    export CURRENT_ENV_ACTIVE="$ENV_ARG"
    echo "Environment '$ENV_ARG' is now active."
else
    echo "Error: Secrets for '$PROJECT_NAME' ($ENV_ARG) not found in pass."
    echo "Check: pass show $PASS_PATH"
    exit 1
fi
