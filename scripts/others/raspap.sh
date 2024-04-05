#!/bin/bash
# shellcheck shell=bash source=/dev/null disable=SC2154

: '
This script initializes RaspAP on the Raspberry Pi.
RaspAP is a web interface to manage a wireless access point.

The SSID is changed to "DemoJ".
The password is removed.
'

# Including utility functions
source "$(dirname "$0")"/utils.sh

user="$SUDO_USER"

if [ "$user" != "network" ]; then
    echo "User is not network"
    exit 1
fi

echo "Initializing RaspAP"

echo -e "${ORANGE}After reboot, remember to disable your personal hotspot to let RaspAP take over ${RESET}"

echo "Configuring default language"

# Not sure if this command is working
# Check: https://www.raspberrypi.com/documentation/computers/configuration.html
raspi-config nonint do_wifi_country FR >> "$log_file" 2>&1 || die "Failed to configure default language"

echo "Installing RaspAP"
(curl -sL https://install.raspap.com | bash -s -- --yes --wireguard 0 --adblock 0 --openvpn 0 --provider 0) >> "$log_file" 2>&1 || die "Failed to install RaspAP"

echo "Configuring RaspAP"
file="/etc/hostapd/hostapd.conf"

echo "Creating backup of $file"
create_bak "$file" >> "$log_file" 2>&1 || die "Failed to create backup of $file"

echo "Removing wifi password"
sed -i '/auth_algs=1/s/^/#/g' "$file"
sed -i '/wpa_key_mgmt=WPA-PSK/s/^/#/g' "$file"
sed -i '/wpa=2/s/^/#/g' "$file"
sed -i '/wpa_pairwise=cCMp/s/^/#/g' "$file"

echo "Changing SSID to DemoJ"
sed -i 's/ssid=raspi-webgui/ssid=DemoJ/g' "$file"

# TODO: Update default login and password to portal

echo -e "${GREEN}RaspAP initialized ${RESET}"

exit 0