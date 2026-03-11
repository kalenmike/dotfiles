#!/usr/bin/env bash

# Check ufw status
# Only works with `sudo visudo` escalation.
# yourusername ALL=(ALL) NOPASSWD: /usr/sbin/ufw status
#
# STATUS=$(sudo ufw status | grep -o "inactive" || echo "active")
STATUS=$(grep -q "ENABLED=yes" /etc/ufw/ufw.conf && echo "active" || echo "inactive")

if [ "$STATUS" = "active" ]; then
    echo "%{T9}%{F179299}󰒘 %{F-}%{T-}"
else
    echo "%{T9}%{F5c5f77}󰒙 %{F-}%{T-}"
fi
