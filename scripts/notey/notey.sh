#!/usr/bin/env bash

# Symlink into bin
# ~/.local/bin

# Usage:
# nt [show|list|add|delete|edit] <alias>

# --- Variables ----

CONFIG_DIR="$HOME/.config/notey"
STYLES="$CONFIG_DIR/style.json"
NOTES_DIR="$CONFIG_DIR/db"
EXT="md"
VERSION="0.1.0-dev"
RELEASE_DATE="2026-03-07"

# --- Core Functions ---

ensure_dir() {
    if [[ ! -d "$NOTES_DIR" ]]; then
        mkdir -p "$NOTES_DIR"
    fi
}

add_note() {
    ensure_dir
    local note_file="$1"
    local note_path="$NOTES_DIR/$note_file.$EXT"

    if [[ ! -f "$note_path" ]]; then
        touch "$note_path"
    fi
    edit_note "$note_file"
}

edit_note() {
    local note_file="$NOTES_DIR/$1.$EXT"
    if [[ ! -f "$note_file" ]]; then
        error_not_found "$note_file"
    fi
    ${EDITOR:-nano} "$note_file"
}

view_note() {
    local note_file="$NOTES_DIR/$1.$EXT"
    if [[ -f "$note_file" ]]; then
        glow -s "$STYLES" "$note_file"
    else
        error_not_found "$note_file"
    fi
}

list_notes() {
    shopt -s nullglob
    local files=("$NOTES_DIR"/*."$EXT")
    if [ ${#files[@]} -eq 0 ]; then
        error_no_notes
    else
        for f in "${files[@]}"; do
            filename=$(basename "$f")
            echo "${filename%.*}"
        done
    fi

    shopt -u nullglob
}

remove_note() {
    local note_file="$1"
    local note_path="$NOTES_DIR/$note_file.$EXT"
    if [[ ! -f "$note_path" ]]; then
        error_not_found "$note_path"
        exit 1
    fi
    read -p "Permanently remove $note_file? (y/n) " confirm
    if [[ "$confirm" == [yY] ]]; then
        rm "$note_path"
        echo "$note_file removed."
    fi
}

handle_pipe_input() {
    local note_file="$NOTES_DIR/$1.$EXT"
    # Read stdin into a variable
    local input_data

    if [[ -f "$note_file" ]]; then
        input_data=$(cat)

        # Append the input to the file
        echo "$input_data" >>"$note_file"
    else
        error_not_found $1
    fi
}

# --- Helper Functions ---

show_version() {
    echo "Notey version $VERSION ($RELEASE_DATE) © 2026 Kalen Michael"
}

show_help() {
    # TODO
    show_short_help
}

show_short_help() {
    echo "Usage: nt [add|edit|list|remove|version|help] <args>"
}

check_alias() {
    if [[ -z "$1" ]]; then
        error_no_alias
        exit 1
    fi
}

check_glow() {
    if ! command -v glow &>/dev/null; then
        echo "Error: 'glow' is not installed."
        echo "Please install it to view rendered markdown notes:"
        echo "  - Ubuntu/Debian: sudo apt install glow"
        echo "  - macOS: brew install glow"
        exit 1
    fi
}

check_fzf() {
    if ! command -v fzf &>/dev/null; then
        echo "Error: 'fzf' is not installed."
        echo "Please install it to preview all notes:"
        echo "  - Ubuntu/Debian: sudo apt install fzf"
        echo "  - macOS: brew install fzf"
        exit 1
    fi
}
# --- Error Functions ---

error_not_found() {
    note_file=$(basename $1)
    echo "'${note_file%.*}' not found. Start by using the 'add' command."
}

error_no_notes() {
    echo "Notey is empty. Start by using the 'add' command or see help for more info."
}

error_no_alias() {
    echo "An alias must be provided. See help for more info."
}

# --- Dependency Check ---
check_glow
check_fzf

case "$1" in
add)
    check_alias $2
    add_note $2
    ;;
show)
    check_alias $2
    view_note $2
    ;;
list)
    note=$(list_notes | fzf --preview "glow -s "$STYLES" $NOTES_DIR/{}.md")
    if [[ -z "$note" ]]; then
        exit 0
    fi
    view_note $note
    ;;
edit)
    check_alias $2
    edit_note $2
    ;;
remove)
    check_alias $2
    remove_note $2
    ;;
version)
    show_version
    ;;
help)
    show_help
    ;;
"")
    show_short_help
    exit 1
    ;;
*)
    check_alias $1
    if [[ ! -t 0 ]]; then
        handle_pipe_input "$1"
        exit 0
    fi

    check_alias $1
    view_note $1
    ;;
esac
