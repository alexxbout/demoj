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

ssid="DemoJ"
static_ip=""
mask="24"
gateway="10.3.141.1"
dns="$gateway"

if [ "$user" = "terminal" ]; then
    static_ip="10.3.141.2"
elif [ "$user" = "server" ]; then
    static_ip="10.3.141.3"
fi

# Initialize the network service
echo "Initializing network service"
nmcli connection add type wifi ifname wlan0 ssid "$ssid"
nmcli connection modify "wifi-wlan0" ipv4.method manual ipv4.addresses $static_ip/$mask ipv4.gateway $gateway ipv4.dns $dns

echo -e "${GREEN}Network service initialized ${RESET}"

exit 0