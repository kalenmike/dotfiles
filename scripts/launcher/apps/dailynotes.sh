#!/usr/bin/env bash
# Class configured in i3 for specific launch parameters

NOTES_DIR="$HOME/Documents/notes/Agenda"
DATE=$(date +%Y-%m-%d)
LANDING_NOTE="$NOTES_DIR/$DATE.md"

kitty --class "dailyNotes" --directory $NOTES_DIR zsh -i -c "nv $LANDING_NOTE" &
