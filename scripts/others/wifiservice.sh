#!/bin/bash
# shellcheck shell=bash source=/dev/null disable=SC2154

: '
This script initializes the wifi for the DemoJ project.
'

# Including utility functions
source "$(dirname "$0")"/utils.sh

# Checking if the script is executed as root
check_root

# Get the user
user="$SUDO_USER"

# Defining paths
service_name="network.service"
network_script="/home/$user/scripts/daemons/network.sh"
file="/etc/systemd/system/$service_name"

# Creating and writing to the service file
cat <<EOL >"$file"
[Unit]
Description=Start $user network service

[Service]
ExecStart=$network_script

[Install]
WantedBy=multi-user.target
EOL

# Enabling the service
echo "Enabling $service_name"
systemctl enable $service_name >> "$log_file" 2>&1 || die "Failed to enable $service_name"

echo -e "${GREEN}Network service initialized ${RESET}"

exit 0