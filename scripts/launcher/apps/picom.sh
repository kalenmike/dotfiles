#!/usr/bin/env bash
# Launch picom transparency

# Standard transparency
picom -b --experimental-backends --xrender-sync-fence --config $HOME/.config/picom/config 
