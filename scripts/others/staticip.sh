#!/usr/bin/sudo bash
# shellcheck shell=bash

echo "Initializing static IP"

read -rp "Enter the static IP address: " static_ip
read -rp "Enter the router/gateway address: " gateway
read -rp "Enter the subnet mask: " subnet_mask
read -rp "Enter the WLAN interface name: " wlan_interface

file="/etc/dhcpcd.conf"

if [ -f $file ]; then
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

cat <<EOL >$file
interface $wlan_interface
static ip_address=$static_ip/$subnet_mask
static routers=$gateway
static domain_name_servers=8.8.8.8 8.8.4.4
EOL

systemctl restart networking

echo "Static IP configured successfully."

exit 0
