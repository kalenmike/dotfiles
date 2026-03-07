#!/usr/bin/env bash
# Allow the system to sleep

for dev in $(grep enabled /proc/acpi/wakeup|cut -f 1); do
    echo -n "disabling acpi wakeup: "
    echo $dev | sudo tee /proc/acpi/wakeup
done
