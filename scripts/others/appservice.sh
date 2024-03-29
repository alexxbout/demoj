#!/bin/bash
# shellcheck shell=bash source=/dev/null disable=SC2154

# Including utility functions
source "$(dirname "$0")"/utils.sh

# Checking if the script is executed as root
check_root

# Get the user
user="$SUDO_USER"

# Defining paths
venv_path="/home/$user/demoj/venv/bin/python3"
app_script="/home/$user/demoj/module/scripts/app.py"
service_file="/etc/systemd/system/app.service"

# Creating and writing to the service file
({
    echo "[Unit]"
    echo "Description=Start $user app"
    echo ""
    echo "[Service]"
    echo "ExecStart=$venv_path $app_script"
    echo "Restart=always"
    echo ""
    echo "[Install]"
    echo "WantedBy=multi-user.target"
} > "$service_file") >> "$log_file" 2>&1 || die "Failed to create service file: $service_file"

# Enabling the service
echo "Enabling app.service"
systemctl enable app.service >> "$log_file" 2>&1 || die "Failed to enable app.service"

echo -e "${GREEN}App service initialized ${RESET}"

exit 0