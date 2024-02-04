#!/usr/bin/sudo bash
# shellcheck shell=bash

echo "Initializing RaspAP"

echo "After reboot, remember to disable your personal hotspot to let RaspAP take over"

echo "Configuring default language"

# TODO

echo "Installing RaspAP"

curl -sL https://install.raspap.com | bash -s -- --yes --wireguard 0 --adblock 0 --openvpn 0 --provider 0

echo "RaspAP installed"

exit 0