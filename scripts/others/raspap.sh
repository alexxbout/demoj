#!/bin/bash
# shellcheck shell=bash source=/dev/null

# Including utility functions
source "$(dirname "$0")"/utils.sh

# Redirecting output to log file
redirect_output

echo "Initializing RaspAP"

echo "After reboot, remember to disable your personal hotspot to let RaspAP take over"

echo "Configuring default language"

# Not sure if this command is working
# Check: https://www.raspberrypi.com/documentation/computers/configuration.html
raspi-config nonint do_wifi_country FR

echo "Installing RaspAP"

curl -sL https://install.raspap.com | bash -s -- --yes --wireguard 0 --adblock 0 --openvpn 0 --provider 0

echo "RaspAP installed"

echo "Configuring RaspAP"

file="/etc/hostapd/hostapd.conf"

echo "Creating backup of $file"
create_bak "$file"

# TODO: Change default SSID: Maybe here /etc/raspap/raspap.auth or /etc/hostapd/hostapd.conf
echo "Changing default SSID"
sed -i 's/^ssid=raspi-webgui/ssid=NewSSID/' /etc/hostapd/hostapd.conf

# TODO: Maybe remove the password: https://docs.raspap.com/faq/#can-i-remove-the-ap-password-to-create-an-open-wifi-network
echo "Removing default password"
sed -i '/wpa_passphrase=/s/^/#/g' /etc/hostapd/hostapd.conf

# TODO: Update default login and password to portal

echo "RaspAP configured"

exit 0