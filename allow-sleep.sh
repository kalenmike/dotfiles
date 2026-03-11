#!/usr/bin/env bash
# Manage Devices that can Wake

function get_enabled() {
    echo $(grep enabled /proc/acpi/wakeup | cut -f 1 | sort | uniq)
}

function get_disabled() {
    echo $(grep disabled /proc/acpi/wakeup | cut -f 1 | sort | uniq)
}

function pretty_print() {
    for dev in $@; do
        name=$(get_pretty_name $dev)
        echo "$dev ($name)"
    done
}

function disable_all() {
    # Find all enabled wakeup devices
    devices=$(get_enabled)

    for dev in $devices; do
        name=$(get_pretty_name $dev)

        # Disable the device
        echo "Disabling wakeup for: $dev ($name)"
        echo "$dev" | sudo tee /proc/acpi/wakeup >/dev/null
    done
}

function get_pretty_name_() {
    # Look for a matching PCI address in sysfs to get a description
    pci_addr=$(grep -l "$1" /sys/bus/pci/devices/*/firmware_node/path 2>/dev/null | awk -F/ '{print $6}' | head -n 1)
    if [ -n "$pci_addr" ]; then
        name=$(lspci -s "$pci_addr" | cut -d' ' -f2-)
    else
        # Fallback for non-PCI devices (like AWAC/System Clock or XHCI/USB)
        name="System Device / Controller"
    fi

    echo $name
}

function get_pretty_name() {
    local dev_code="$1"
    # 1. Find the ACPI path for this device code
    local acpi_path=$(grep -l "$dev_code" /sys/bus/pci/devices/*/firmware_node/path 2>/dev/null | head -n 1)

    if [ -z "$acpi_path" ]; then
        # Handle non-PCI stuff like AWAC (Clock) or PS2K (Keyboard)
        case "$dev_code" in
        AWAC) echo "System Clock / RTC" ;;
        PS2K) echo "PS/2 Keyboard" ;;
        XHCI) echo "USB Controller (Mouse/Keyboard)" ;;
        *) echo "System Device" ;;
        esac
        return
    fi

    # 2. Get the PCI address of the Bridge
    local bridge_addr=$(echo "$acpi_path" | awk -F/ '{print $6}')

    # 3. Find the "Children" (devices connected to this bridge)
    # We look for PCI devices whose 'parent' is our bridge_addr
    local child_addr=$(ls -l /sys/bus/pci/devices/ | grep "$bridge_addr" | grep -v "$bridge_addr$" | awk '{print $9}' | head -n 1)

    if [ -n "$child_addr" ]; then
        # If there's a child, tell us what that child is (e.g., the actual Wi-Fi card)
        echo "$(lspci -s "$child_addr" | cut -d' ' -f2-) [via $dev_code]"
    else
        # If no child, just name the bridge itself
        echo "$(lspci -s "$bridge_addr" | cut -d' ' -f2-)"
    fi
}

case "$1" in
enabled)
    echo "Devices Enabled to Wake from Sleep:"
    echo "------------------------------------"
    enabled=$(get_enabled)
    pretty_print $enabled

    ;;
disabled)
    echo "Devices Disabled from Wake from Sleep:"
    echo "------------------------------------"
    disabled=$(get_disabled)
    pretty_print $disabled
    ;;
disable-all)
    disable_all
    ;;
*)
    echo "Usage: $0 {enabled|disabled|disable-all}"
    exit 1
    ;;
esac
