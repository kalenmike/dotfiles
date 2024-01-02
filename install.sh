#!/bin/bash

# Enable dot file matching
shopt -s dotglob

# Home directory
HOME_DIR="/home/ace"

# Config Directory
CONFIG_DIR="$HOME_DIR/.config"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Check if the source folder exists.
if [ ! -d "$HOME_DIR" ]; then
  echo "Home folder does not exist: $HOME_DIR"
  exit 1
fi

# Check if the source folder exists.
if [ ! -d "$CONFIG_DIR" ]; then
  echo "Config folder does not exist: $CONFIG_DIR"
  exit 1
fi

link_all_files(){
    source=$1
    target=$2
    # Loop through files in the source folder.
    for file in "$source"/*; do
        # Extract the file name without the path.
        filename=$(basename "$file")
        
        source_file=$(realpath $SCRIPT_DIR/$file)
        target_file=$target/$filename
        
        if [ -e "$target_file" ]; then
            mv "$target_file" "$target_file-bkp"
            echo "File exists, creating backup: $target_file-bkp"
        fi

        # Create a symlink in the target folder.
        ln -s "$SCRIPT_DIR/$file" "$target/$filename"
        
        echo "Created symlink: $target_file -> $source_file"
    done
}

link_all_files "./dot-files/home" $HOME_DIR
link_all_files "./dot-files/config" $CONFIG_DIR 

# Disable dot file matching
shopt -s dotglob
