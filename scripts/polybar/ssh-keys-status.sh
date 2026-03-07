#!/usr/bin/env bash

# This script checks and outputs whether the ssh agent has
# loaded keys

LOADED_KEYS=$(ssh-add -l)

if [[ $LOADED_KEYS == *"no identities"* ]]; then
    # No Keys
    echo '%{T9}%{F5c5f77} 󰌋 %{O-10}%{F-}%{T-}'
else
    # Keys
    echo '%{T9}%{F179299} 󰌋 %{O-10}%{F-}%{T-}'
fi
