#!/usr/bin/env bash

# This script checks and outputs whether the ssh agent has
# loaded keys

LOADED_KEYS=$(ssh-add -l)

if [[ $LOADED_KEYS == *"no identities"* ]]; then
    echo '%{T12}%{FC33B23} 󰣀 %{F-}%{T-}'
else
    echo '%{T12}%{F009777} 󰣀 %{F-}%{T-}'
fi
