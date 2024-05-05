#!/bin/bash
# shellcheck shell=bash source=/dev/null disable=SC2154

: '
This script initializes the DNS server.
The DNS server is configured to redirect all traffic comming from port 5000 to port 80.
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

# Update dns in /etc/dnsmasq.d/090_wlan0.conf
echo "Updating default DNS values of RaspAP"
sed -i 's/dhcp-option=6,9.9.9.9,1.1.1.1/dhcp-option=6,10.3.141.1,10.3.141.1/g' /etc/dnsmasq.d/090_wlan0.conf

# Redirect port 80 to 5000
echo "Redirecting port 80 to 5000"
echo "Note: This will disable the web interface of RaspAP"
echo "Do this command to reenable the web interface of RaspAP"
echo "sudo iptables -t nat -D PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 5000"
iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 5000 >> "$log_file" 2>&1 || die "Failed to redirect port 80 to 5000"

# Activate IP forwarding
echo "Activating IP forwarding"
sysctl -w net.ipv4.ip_forward=1 >> "$log_file" 2>&1 || die "Failed to activate IP forwarding"

# Create a service to restore iptables rules
echo "Creating a service to restore iptables rules"
echo "[Unit]
Description=Restore iptables rules
After=network.target

[Service]
Type=oneshot
ExecStart=iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 5000

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/restore-iptables-rules.service

# Enable the service
echo "Enabling the service"
systemctl enable restore-iptables-rules >> "$log_file" 2>&1 || die "Failed to enable the service"

# Add demoj.fr to dnsmasq.conf
echo "Adding demoj.fr to dnsmasq.conf"
echo "address=/demoj.fr/10.3.141.1" >> /etc/dnsmasq.conf

# Restarting dnsmasq
echo "Restarting dnsmasq"
systemctl restart dnsmasq >> "$log_file" 2>&1 || die "Failed to restart dnsmasq"

# Finalization message
echo -e "${GREEN}DNS initialized ${RESET}"
exit 0
