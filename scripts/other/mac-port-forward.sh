#!/usr/bin/env bash

# ./mac-port-forward.sh connect && proxychains4 -q node index.js && ./mac-port-forward.sh undo

# --- CONFIGURATION ---
# Friend: Change these to your friend's details
REMOTE_USER="alvaro"
REMOTE_IP="170.253.55.45"
REMOTE_PORT="54321"
PORT="1080"

PROXY_CONF="/usr/local/etc/proxychains.conf"
[[ $(uname -m) == 'arm64' ]] && PROXY_CONF="/opt/homebrew/etc/proxychains.conf"

install_proxy() {
    echo "--- Installing dependencies ---"
    if ! command -v brew &> /dev/null; then
        echo "Error: Homebrew not found. Install it at https://brew.sh"
        exit 1
    fi
    brew install proxychains-ng
}

setup_all() {
    echo "--- Configuring Proxychains ---"
    [ -f "$PROXY_CONF" ] && sudo cp "$PROXY_CONF" "${PROXY_CONF}.bak"
    sudo bash -c "cat <<EOF > $PROXY_CONF
strict_chain
proxy_dns
[ProxyList]
socks5  127.0.0.1 $PORT
EOF"
    echo "Configuration written to $PROXY_CONF"
}

connect_ssh() {
    echo "--- Opening SSH Tunnel to $REMOTE_IP (Background) ---"
    # -D: SOCKS proxy, -f: Background, -N: No command, -C: Compression
    ssh -p $REMOTE_HOST -D $PORT -f -N -C "$REMOTE_USER@$REMOTE_IP"
    
    if [ $? -eq 0 ]; then
        echo "Tunnel active on port $PORT. Your IP is now being masked."
        echo "Run your script with: proxychains4 -q node your_script.js"
    else
        echo "Failed to establish SSH connection."
    fi
}

undo_all() {
    echo "--- Closing SSH Tunnel and Restoring Config ---"
    # Find the SSH process running the tunnel and kill it
    PID=$(pgrep -f "ssh -D $PORT")
    if [ -n "$PID" ]; then
        kill "$PID"
        echo "SSH Tunnel (PID $PID) closed."
    else
        echo "No active tunnel found."
    fi

    if [ -f "${PROXY_CONF}.bak" ]; then
        sudo mv "${PROXY_CONF}.bak" "$PROXY_CONF"
        echo "Proxy config restored."
    fi
}

uninstall_all() {
    undo_all
    brew uninstall proxychains-ng
    echo "Uninstalled."
}

case "$1" in
    install)   install_proxy ;;
    setup)     setup_all ;;
    connect)   connect_ssh ;;
    undo)      undo_all ;;
    uninstall) uninstall_all ;;
    *)         echo "Usage: $0 {install|setup|connect|undo|uninstall}" ;;
esac
