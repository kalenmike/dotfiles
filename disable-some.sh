#!/usr/bin/env bash

# echo Disabling NVIDIA Card Wakeup
# echo "PEG1" | sudo tee /proc/acpi/wakeup >/dev/null
# echo Disabling Ethernet Card Wakeup
# echo "RP03" | sudo tee /proc/acpi/wakeup >/dev/null
echo Disabling USB Wakeup
echo "XHCI" | sudo tee /proc/acpi/wakeup >/dev/null
