#!/usr/bin/sudo bash
# shellcheck shell=bash

# args: user

echo "Initialising RaspAP"

user=$1

if [ "$user" != "network" ]; then
    echo "Invalid user"
    exit 1
fi

echo "After reboot, remember to disable your personal hotspot to let RaspAP take over"

echo "Configuring default language"

# TODO

echo "Installing RaspAP"

curl -sL https://install.raspap.com | bash -s -- --yes --wireguard 0 --adblock 0 --openvpn 0 --provider 0

echo "RaspAP installed"

exit 0