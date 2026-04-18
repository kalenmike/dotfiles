#!/usr/bin/env bash

# --- CONFIGURATION ---
NEW_USER="alvaro"
PUBLIC_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKgp+oj10TFrm3fCNsHDU7g90VDY17CDyFkd3kRhSdoG "

echo "--- Creating Non-Root User: $NEW_USER ---"

# 1. Create the user with a home directory and bash shell
# We do NOT add them to 'sudo' or 'wheel' groups
sudo useradd -m -s /bin/bash "$NEW_USER"

# 2. Set up the .ssh directory
USER_HOME="/home/$NEW_USER"
sudo mkdir -p "$USER_HOME/.ssh"

# 3. Add the public key to authorized_keys
echo "$PUBLIC_KEY" | sudo tee "$USER_HOME/.ssh/authorized_keys" >/dev/null

# 4. Set strict permissions (SSH will fail if these are too open)
sudo chmod 700 "$USER_HOME/.ssh"
sudo chmod 600 "$USER_HOME/.ssh/authorized_keys"
sudo chown -R "$NEW_USER:$NEW_USER" "$USER_HOME/.ssh"

echo "--- User $NEW_USER created successfully ---"
echo "They can now connect via: ssh -p YOUR_PORT $NEW_USER@your_ip"
