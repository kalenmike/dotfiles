#!/usr/bin/env bash

# Usage: 
# . loadenv production  <- Load secrets
# . loadenv             <- Check status
# . loadenv unset       <- Clear secrets

PROJECT_NAME=$(basename "$PWD")
INPUT=$(echo "$1" | tr '[:upper:]' '[:lower:]')

case "$INPUT" in
    d|dev)
        ENV_ARG="development"
        ;;
    p|prod)
        ENV_ARG="production"
        ;;
    s|stag)
        ENV_ARG="staging"
        ;;
    *)
        # If no match is found, return the original input
        ENV_ARG="$1"
        ;;
esac

safe_exit() {
    if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
        return "$1" # We are being sourced
    else
        exit "$1"   # We are being executed
    fi
}

unload_env() {
    if [ -z "$CURRENT_ENV_ACTIVE" ]; then
        return 0
    fi

    PASS_PATH="env/$PROJECT_NAME/$CURRENT_ENV_ACTIVE"
    keys=$(pass show "$PASS_PATH" 2>/dev/null | cut -d'=' -f1)

    for key in $keys; do
        if [[ "$key" =~ ^[A-Za-z0-9_]+$ ]]; then
            unset "$key"
        fi
    done

    echo "Unloaded environment: [$CURRENT_ENV_ACTIVE]"
    unset CURRENT_ENV_ACTIVE
    safe_exit 0
}

# ---  THE STATUS CHECK (No Args) ---
if [ -z "$ENV_ARG" ]; then
    if [ -z "$CURRENT_ENV_ACTIVE" ]; then
        echo "No environment currently loaded for $PROJECT_NAME."
    else
        echo -e "Active Environment: [\e[38;5;110m$CURRENT_ENV_ACTIVE\e[0m]"
    fi
    safe_exit 0
fi


# Checks if the script is being executed rather than sourced
if [[ "$0" == "${BASH_SOURCE[0]}" || "$0" == "$BASH_ARGV0" ]]; then
    echo "Error: This script must be sourced to modify your environment."
    echo "Usage: . loadenv $1 (Note the dot at the beginning)"
    exit 1
fi

# ---  THE UNSET/CLEAR LOGIC ---
if [ "$ENV_ARG" = "unset" ] || [ "$ENV_ARG" = "clear" ]; then
    if [ -z "$CURRENT_ENV_ACTIVE" ]; then
        echo "No environment is currently loaded."
    else
        unload_env
    fi
    return 0
fi

# --- 3. THE LOADING LOGIC ---
PASS_PATH="env/$PROJECT_NAME/$ENV_ARG"

if secrets=$(pass show "$PASS_PATH" 2>/dev/null); then
    # If switching envs, unset the old one first to avoid ghost variables
    if [ -n "$CURRENT_ENV_ACTIVE" ] && [ "$CURRENT_ENV_ACTIVE" != "$ENV_ARG" ]; then
        unload_env > /dev/null
    fi

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
    echo -e "Environment [\e[38;5;110m$ENV_ARG\e[0m] is now active for \e[38;5;110m$PROJECT_NAME\e[0m."
else
    echo "Error: Secrets for '$PROJECT_NAME' ($ENV_ARG) not found in pass."
    echo "Check: pass show $PASS_PATH"
    safe_exit 1
fi
