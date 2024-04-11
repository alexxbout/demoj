#!/bin/bash
# shellcheck shell=bash source=/dev/null disable=SC2154

# ! NEED TO BE TESTED

: '
'

# Including utility functions
source "$(dirname "$0")"/utils.sh

# Checking if the script is executed as root
check_root

user="$SUDO_USER"

if [ "$user" != "network" ]; then
    echo "User is not network"
    exit 1
fi

# Displaying initialization message
echo "Initializing DNS"

# Redirect port 80 to 5000
echo "Redirecting port 80 to 5000"
echo "Note: This will disable the web interface of RaspAP"
echo "Do this command to reenable the web interface of RaspAP"
echo "sudo iptables -t nat -D PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 5000"
iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 5000

# Activate IP forwarding
echo "Activating IP forwarding"
sysctl -w net.ipv4.ip_forward=1

# Add demoj.fr to dnsmasq.conf
echo "Adding demoj.fr to dnsmasq.conf"
echo "address=/demoj.fr/10.3.141.1" >> /etc/dnsmasq.conf

# Restarting dnsmasq
echo "Restarting dnsmasq"
systemctl restart dnsmasq