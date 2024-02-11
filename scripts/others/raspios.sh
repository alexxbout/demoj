#!/bin/bash
# shellcheck shell=bash source=/dev/null

# Including utility functions
source "$(dirname "$0")"/utils.sh

# Redirecting output to log file
redirect_output

# Checking if the script is executed as root
check_root

# Displaying initialization message
echo "Initializing raspios"

# Updating the system
echo "Updating system"
apt update -y
apt -y full-upgrade

# Installing pip
echo "Installing pip"
apt install python3-pip -y

# Installing venv
echo "Installing venv"
apt install python3.11-venv -y

# Installing build-essential
echo "Installing build-essential"
apt install build-essential -y

# Installing smbus package via pip
echo "Installing smbus"
pip3 install smbus --break-system-packages

# Installing rpi_ws281x package via pip
echo "Installing strip led API"
pip3 install rpi_ws281x --break-system-packages

# Configuring I2C
echo "Setup I2C"
if [ "$(raspi-config nonint get_i2c)" -eq 0 ]; then
    echo "I2C already enabled"
else
    raspi-config nonint do_i2c 0
    echo "I2C enabled"
fi

# End of Raspios initialization
echo "Raspios initialized"

exit 0
