#!/bin/bash
# shellcheck shell=bash source=/dev/null disable=SC2154

: '
This script initializes the wifi for the DemoJ project.
The script adds a new entry in wpasupplicant.conf with a no password network called DemoJ.
'

# Including utility functions
source "$(dirname "$0")"/utils.sh

# Checking if the script is executed as root
check_root

connection="demoj_connection"
ssid="DemoJ"

# Create a new entry in nmcli
echo "Creating a new wifi connection"
nmcli connection add type wifi ifname wlan0 con-name $connection ssid $ssid >> "$log_file" 2>&1 || die "Failed to create a new wifi connection"

# Removing password from the wifi connection
echo "Removing password from the wifi connection"
nmcli connection modify $connection wifi-sec.key-mgmt none >> "$log_file" 2>&1 || die "Failed to remove password from the wifi connection"

# Configure autoconnection and retry parameters
echo "Configuring autoconnection and retry parameters"
nmcli connection modify $connection connection.autoconnect yes >> "$log_file" 2>&1 || die "Failed to configure autoconnection"
nmcli connection modify $connection connection.auth-retries 0 >> "$log_file" 2>&1 || die "Failed to configure auth retries"
nmcli connection modify $connection connection.autoconnect-priority 1 >> "$log_file" 2>&1 || die "Failed to configure autoconnection priority"
nmcli connection modify $connection connection.autoconnect-retries 0 >> "$log_file" 2>&1 || die "Failed to configure autoconnection retries"

nmcli connection modify $connection connection.mode auto >> "$log_file" 2>&1 || die "Failed to configure mode"
# nmcli connection modify $connection ipv4.method auto >> "$log_file" 2>&1 || die "Failed to configure IPv4 method"

echo -e "${GREEN}Wifi setup complete ${RESET}"

exit 0