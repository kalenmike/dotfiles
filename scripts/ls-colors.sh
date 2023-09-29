#!/usr/bin/env bash

# Requires vivid
# https://github.com/sharkdp/vivid

# Display all themes
for theme in $(vivid themes); do
    echo "Theme: $theme"
    export LS_COLORS=$(vivid generate $theme) && ls -a ~ --color=always
    echo
done
