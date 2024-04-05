#!/bin/bash
# shellcheck shell=bash source=/dev/null disable=SC2154

: '
This script initializes the wifi for the demoj project.
The script adds a new entry in wpasupplicant.conf with a no password network called demoj.
'

# Including utility functions
source "$(dirname "$0")"/utils.sh

# Checking if the script is executed as root
check_root

# Add a new entry in wpasupplicant.conf with a no password network called demoj
echo "Adding a new entry in wpasupplicant.conf"
cat <<EOL >> /etc/wpa_supplicant/wpa_supplicant.conf
network={
    ssid="demoj"
    key_mgmt=NONE
}
EOL

# Restarting the network service
echo "Restarting the network service"
systemctl restart networking.service >> "$log_file" 2>&1 || die "Failed to restart the network service"

echo -e "${GREEN}Wifi setup complete ${RESET}"

exit 0