#!/bin/bash
# shellcheck shell=bash source=/dev/null

# Inclusion of utility functions
source "$(dirname "$0")"/utils.sh

# Check if the script is executed as root
check_root

# Display initialization message
echo "Initializing static IP"

# Read parameters
read -rp "Enter the static IP address: " static_ip
read -rp "Enter the router/gateway address: " gateway
read -rp "Enter the subnet mask: " subnet_mask
read -rp "Enter the WLAN interface name: " wlan_interface

# Configuration file location
file="/etc/dhcpcd.conf"

# Check if the file already exists
if [ -f "$file" ]; then
    read -rp "The file $file already exists. Do you want to overwrite it? (y/n) " overwrite
    case $overwrite in
        [yY])
            echo "Overwriting $file"
            ;;
        *)
            echo "Exiting..."
            exit 1
            ;;
    esac
fi

# Write the configuration to the file
cat <<EOL >"$file" || die "Failed to write to $file"
interface $wlan_interface
static ip_address=$static_ip/$subnet_mask
static routers=$gateway
static domain_name_servers=8.8.8.8 8.8.4.4
EOL

# Restart the networking service
systemctl restart networking

echo "Static IP configured successfully."

exit 0
