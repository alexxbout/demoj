#!/bin/bash
# shellcheck shell=bash source=/dev/null disable=SC2154

: '
This script initializes the static IP for the demoj project.

Network: 10.3.141.1
Terminal: 10.3.141.2
Server: 10.3.141.3
'

# Inclusion of utility functions
source "$(dirname "$0")"/utils.sh

# Check if the script is executed as root
check_root

# Display initialization message
echo "Initializing static IP"

# Get the user
user="$SUDO_USER"

# Configuration file location
file="/etc/dhcpcd.conf"

# Check if the file already exists
if [ -f "$file" ]; then
    echo "Creating backup of $file"
    create_bak "$file"
fi

wlan_interface="wlan0"
static_ip=""

if [ "$user" = "terminal" ]; then
    static_ip="10.3.141.2"
elif [ "$user" = "server" ]; then
    static_ip="10.3.141.3"
fi

subnet_mask="24"
gateway="10.3.141.1"

# Write the configuration to the file
cat <<EOL >"$file"
interface $wlan_interface
static ip_address=$static_ip/$subnet_mask
static routers=$gateway
static domain_name_servers=8.8.8.8 8.8.4.4
EOL

# Restart the networking service
echo "Restarting networking service"
systemctl restart networking >> "$log_file" 2>&1 || die "Failed to restart networking service"

echo -e "${GREEN}Static IP configured successfully ${RESET}"

exit 0
