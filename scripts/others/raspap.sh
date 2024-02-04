#!/usr/bin/sudo bash
# shellcheck shell=bash

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

# TODO: Change default SSID and password
# TOdo: Update default login and password to portal

echo "RaspAP configured"

exit 0