#!/usr/bin/env bash

# Required programs
REQUIRED=("git" "zsh" "tmux" "xrandr")

# Optional programs (can be installed manually)
OPTIONAL=("fzf" "bat" "htop" "lazygit")

# Programs that require manual installation (e.g., polybar build)
MANUAL=("polybar")

# Check OS
if [[ "$(uname -s)" != "Linux" ]]; then
    echo "Unsupported OS. Only Debian/Ubuntu Linux is supported."
    exit 1
fi

# Check if apt is available
if ! command -v apt &>/dev/null; then
    echo "apt not found. Only Debian/Ubuntu systems are supported."
    exit 1
fi

echo "Checking required programs..."

for pkg in "${REQUIRED[@]}"; do
    if ! command -v "$pkg" &>/dev/null; then
        echo "Installing $pkg..."
        sudo apt update
        sudo apt install -y "$pkg"
    else
        echo "$pkg is already installed"
    fi
done

echo
echo "=== Manual install required ==="
for pkg in "${MANUAL[@]}"; do
    if ! command -v "$pkg" &>/dev/null; then
        echo "⚠ $pkg needs to be installed manually!"
    else
        echo "$pkg is already installed"
    fi
done

echo
echo "Optional programs (not installed by default): ${OPTIONAL[*]}"
echo "Install manually if desired, e.g.:"
echo "sudo apt install ${OPTIONAL[*]}"

echo
echo "All required dependencies are installed!"
