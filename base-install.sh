#!/usr/bin/env bash
set -e

echo "==> Updating package list..."
sudo apt update && sudo apt upgrade -y

echo "==> Installing X11 base & Window Manager..."
sudo apt install -y --no-install-recommends \
    xserver-xorg \
    xinit \
    i3-wm \
    lightdm \
    dmenu \
    dunst \
    rofi \
    kitty \
    xterm \
    feh \
    network-manager \
    network-manager-applet \
    pulseaudio \
    alsa-utils \
    pavucontrol \
    arandr \
    flameshot \
    slick-greeter \
    polybar \
    picom

echo "==> Installing CLI utilities..."
sudo apt install -y \
    curl \
    git \
    rsync \
    htop \
    unzip \
    openssh-server \
    build-essential \
    sshfs \
    zsh \
    tmux \
    fzf \
    bat \
    lazygit \
    ncdu \
    pass \
    jdupes \
    bind9-dnsutils \
    wireguard \
    ffmpeg \
    imagemagick \
    vlc \
    conky-all

# node nvm pnpm go opencode brave ollama uv nvim docker docker-compose python thunar speedtest-cli lxappearence cmatrix
#
# localsend obsstudio spotify inkscape davinciresolve darktable audacity digikam

# Brave Browser: curl -fsS https://dl.brave.com/install.sh | sh
# OpenCode: curl -fsSL https://opencode.ai/v2/install | bash

# NodeVersionManager nvm: curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

echo "==> Done! Run 'startx' or configure startx in .bash_profile."
