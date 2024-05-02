#!/bin/bash
# shellcheck shell=bash source=/dev/null disable=SC2154

: '
This script initializes the Raspios for the demoj project.
The script updates the system, installs pip, venv, and build-essential.
The script also configures I2C.
'

# Including utility functions
source "$(dirname "$0")"/utils.sh

# Checking if the script is executed as root
check_root

# Displaying initialization message
echo "Initializing raspios"

# Updating the system
echo "Updating system"
apt update -y >> "$log_file" 2>&1 || die "Failed to update system"
apt -y full-upgrade >> "$log_file" 2>&1 || die "Failed to upgrade system"

# Installing stress
echo "Installing stress"
apt install stress -y >> "$log_file" 2>&1 || die "Failed to install stress"

# Installing pip
echo "Installing pip"
apt install python3-pip -y >> "$log_file" 2>&1 || die "Failed to install pip"

# Installing venv
echo "Installing venv"
apt install python3.11-venv -y >> "$log_file" 2>&1 || die "Failed to install venv"

# Installing build-essential
echo "Installing build-essential"
apt install build-essential -y >> "$log_file" 2>&1 || die "Failed to install build-essential"

# Configuring I2C
echo "Setup I2C"
if [ "$(raspi-config nonint get_i2c)" -eq 0 ]; then
    echo "I2C already enabled"
else
    raspi-config nonint do_i2c 0 >> "$log_file" 2>&1 || die "Failed to enable I2C"
    echo "I2C enabled"
fi

# End of Raspios initialization
echo -e "${GREEN}Raspios initialized ${RESET}"

exit 0
