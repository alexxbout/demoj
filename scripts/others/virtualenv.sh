#!/bin/bash
# shellcheck shell=bash source=/dev/null

# Including utility functions
source "$(dirname "$0")"/utils.sh

# Checking if the script is executed as root
check_root

# Displaying initialization message
echo "Initializing virtualenv"

# Getting the user
user="$1"

# Checking the validity of the user
valid_users=("terminal" "network" "server")
check_param_in_array "$user" "${valid_users[@]}" || die "Invalid user: " "$user"

# Checking the existence of the demoj directory
check_directory "/home/$user/demoj" || die "Directory /home/$user/demoj does not exist. Please run repository.sh first"

# Installing python3-venv
apt install python3.11-venv -y || die "Failed to install python3.11-venv"

# Moving to the demoj directory
cd "/home/$user/demoj" || exit 1

# Creating the virtual environment
python3 -m venv venv

# Activating the virtual environment
source venv/bin/activate

# Installing dependencies based on the user
if [ "$user" = "terminal" ] || [ "$user" = "server" ]; then
    pip install "python-socketio[client]"
elif [ "$user" = "network" ]; then
    pip install flask flask_cors flask-socketio
fi

# Deactivating the virtual environment
deactivate

echo "Virtualenv initialized"

exit 0
