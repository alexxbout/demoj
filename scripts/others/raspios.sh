#!/usr/bin/sudo bash
# shellcheck shell=bash

# TODO Check if pip paackges have to be installed using venv as well

echo "Initializing raspios"

echo "Updating system"
apt update -y
apt -y full-upgrade

echo "Installing pip"
apt install python3-pip -y

echo "Installing venv"
apt install python3.11-venv -y

echo "Installing build-essential"
apt install build-essential -y

echo "Installing smbus"
pip3 install smbus --break-system-packages

echo "Installing strip led API"
pip3 install rpi_ws281x --break-system-packages

echo "Setup I2C"
if [ "$(raspi-config nonint get_i2c)" -eq 0 ]
then
    echo "I2C already enabled"
else
    raspi-config nonint do_i2c 0
    echo "I2C enabled"
fi

echo "Raspios initialized"

exit 0