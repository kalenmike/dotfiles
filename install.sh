#!/usr/bin/env bash
# Install script for dotfiles

# Define usage function
usage() {
  echo "Usage: $0 [OPTIONS]"
  echo "Options:"
  echo "  -a, --add Add symlinks"
  echo "  -r, --remove Remove symlinks"
  echo "  -l, --list List available configs"
  echo "  -n, --no-prompt Create links without confirmation"
  echo "  -b, --no-backup Do not create backups of existing configs"
  echo "  -v, --verbose            Enable verbose mode"
  echo "  -h, --help               Show this help message"
  exit 1
}

# Check if no arguments were provided
if [ $# -eq 0 ]; then
    usage
    # Optionally, provide more detailed usage information here
    exit 1
fi

BACKUP=1
NO_PROMPT=0
VERBOSE=0

# Parse command line options
while getopts ":arlbnvh" opt; do
  case "$opt" in
    a)
       MODE=add 
      ;;
    r)
        MODE=remove
      ;;
    l)
        MODE=list
      ;;
    b)
      BACKUP=0
      ;;
    n)
      NO_PROMPT=1
      ;;

    o)
      output_file="$OPTARG"
      ;;
    v)
      VERBOSE=1
      ;;
    h)
      usage
      ;;
    :)
      echo "Option -$OPTARG requires an argument."
      usage
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      usage
      ;;
    *)
        usaage
        ;;
  esac
done

# Enable dot file matching
shopt -s dotglob

# Home directory, set this manually if needed
HOME_DIR="$(echo $HOME)"

# Config Directory
if [ -n "$XDG_CONFIG_HOME" ]; then
  CONFIG_DIR="$XDG_CONFIG_HOME"
else
  CONFIG_DIR="$HOME_DIR/.config"
fi

# Check if the home folder exists.
if [ ! -d "$HOME_DIR" ]; then
  echo "Home folder does not exist: $HOME_DIR"
  exit 1
fi

# Check if the source folder exists.
if [ ! -d "$CONFIG_DIR" ]; then
  echo "Config folder does not exist: $CONFIG_DIR"
  exit 1
fi

verbose_echo(){
    if [ "$VERBOSE" == "1" ];then
        echo $1
    fi
}

link_all_files(){
    source=$1
    target=$2

    # Loop through files in the source folder.
    for file in "$source"/*; do
        # Extract the file name without the path.
        filename=$(basename "$file")

        if [ "$filename" != ".config" ];then

                        
            source_file=$(realpath $file)
            target_file="$target/$filename"
            if [ "$NO_PROMPT" == "0" ]; then
                echo -n "Add $filename? [Y/n] "
                read -n 1 -r  answer
                answer=${answer:-y}  # Set default to 'y' if no input is provided
                if [ "$answer" == "n" ] || [ "$answer" == "N" ]; then
                    echo
                    continue
                fi
            fi
            
            local backed_up

            # Backup the original, criteria is backup enabled, target exists and is not symlink to source
            if [ "$BACKUP" == "1" ] && { ([ -e "$target_file" ] && [ ! -L "$target_file" ]) || ([ -L "$target_file" ] && [ "$(readlink "$target_file")" != "$source_file" ]); }; then
                backed_up="(backup created)"
                mv "$target_file" "$target_file-bkp"
            fi
            
            # Create a symlink in the target folder.
            ln -s "$source_file" "$target/$filename"
            verbose_echo "Installed: $filename $backed_up"
    
        fi

    done
}

unlink_all_files(){
    source=$1
    target=$2

    # Loop through files in the source folder.
    for file in "$source"/*; do
        # Extract the file name without the path.
        filename=$(basename "$file")

        if [ "$filename" != ".config" ];then

                        
            source_file=$(realpath $file)
            target_file="$target/$filename"
            if [ "$NO_PROMPT" == "0" ]; then
                echo -n "Remove $filename? [Y/n] "
                read -n 1 -r  answer
                answer=${answer:-y}  # Set default to 'y' if no input is provided
                if [ "$answer" == "n" ] || [ "$answer" == "N" ]; then
                    echo
                    continue
                fi
            fi
            
            # Remove only links if symlink matches
            if [ -e "$target_file" ] && [ -L "$target_file" ] && [ "$(readlink "$target_file")" == "$source_file" ]; then
                rm "$target_file"
                if [ -e $target_file-bkp ]; then
                    mv "$target_file-bkp" "$target_file"
                    verbose_echo "Config removed: $filename. Backup Restored."
                else
                    verbose_echo "Config removed: $filename"
                fi
            fi
        fi

    done
}

list(){
    source=$1
    target=$2

    echo Path: \'$target\'

    # Loop through files in the source folder.
    for file in "$source"/*; do
        # Extract the file name without the path.
        filename=$(basename "$file")

        if [ "$filename" != ".config" ];then

            source_file=$(realpath $file)
            target_file="$target/$filename"

            if [ -e "$target_file" ]; then
                if [ ! -L "$target_file" ] || ([ -L "$target_file" ] && [ "$(readlink "$target_file")" != "$source_file" ]); then
                    echo "$filename : Installed (conflicting)."
                else
                    if [ -e $target_file-bkp ]; then
                        echo "$filename : Installed (backup exists)."
                    else
                        echo "$filename : Installed."
                    fi
                fi
            else
                echo "$filename : Not installed."
            fi
        fi

    done

    echo
}

if [ "$MODE" == "add" ]; then
    link_all_files "./dot-files" $HOME_DIR
    link_all_files "./dot-files/.config" $CONFIG_DIR 
elif [ "$MODE" == "remove" ]; then
    unlink_all_files  "./dot-files" $HOME_DIR
    unlink_all_files "./dot-files/.config" $CONFIG_DIR 
elif [ "$MODE" == "list" ]; then
    list  "./dot-files" $HOME_DIR
    list "./dot-files/.config" $CONFIG_DIR 
fi

# Disable dot file matching
shopt -s dotglob
