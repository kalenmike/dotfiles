#!/usr/bin/env zsh

# ============================================================
# nvim-editor
# Location: ~/.local/bin/nvim-editor
#
# Ensures Node (via nvm) is available for Neovim
# Works in non-interactive shells (git, crontab, etc.)
# ============================================================

export NVM_DIR="${XDG_CONFIG_HOME:-$HOME/.nvm}"

if [ -s "$NVM_DIR/nvm.sh" ]; then
    source "$NVM_DIR/nvm.sh"
    nvm use default >/dev/null 2>&1
fi

exec nvim "$@"
