#!/usr/bin/env bash

if ! command -v vivid &>/dev/null; then
    echo "Vivid is not installed!"
    exit
fi

for theme in $(vivid themes); do
    echo -e "\n\033[1;33m--- Theme: $theme ---\033[0m"
    LS_COLORS=$(vivid generate "$theme") ls -F --color=always $1
done
