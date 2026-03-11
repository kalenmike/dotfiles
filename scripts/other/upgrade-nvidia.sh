#!/usr/bin/env bash

# Clean up old drivers
sudo apt purge '^nvidia-.*'
sudo apt autoremove

# Install the new recommended driver
sudo apt install nvidia-driver-590-open

# Update the initramfs to ensure the new driver is ready for the next boot
sudo update-initramfs -u
