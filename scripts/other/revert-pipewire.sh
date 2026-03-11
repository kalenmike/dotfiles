#!/usr/bin/env bash

install() {
    sudo apt update
    sudo apt install pipewire-audio-client-libraries libspa-0.2-bluetooth libspa-0.2-jack

    sudo apt remove pipewire-media-session

    sudo apt install wireplumber pipewire-pulse

    systemctl --user --now enable pipewire pipewire-pulse wireplumber

    systemctl --user mask pulseaudio.service pulseaudio.socket

    sudo cp /usr/share/doc/pipewire/examples/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d/

}

uninstall() {
    systemctl --user unmask pulseaudio.service pulseaudio.socket

    systemctl --user --now enable pulseaudio.service

    systemctl --user stop pipewire pipewire-pulse wireplumber
}

pactl info | grep "Server Name"
