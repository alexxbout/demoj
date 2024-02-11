#!/bin/bash
# shellcheck shell=bash source=/dev/null

# Including utility functions
source "$(dirname "$0")"/utils.sh

# Redirecting output to log file
redirect_output

# Checking if the script is executed as root
check_root

# Checking arguments
valid_params=("terminal" "network" "server")
user="$1"
check_param_in_array "$user" "${valid_params[@]}" || die "Invalid user"

# Defining paths
venv_path="/home/$user/demoj/venv/bin/python3"
app_script="/home/$user/demoj/module/scripts/app.py"
service_file="/etc/systemd/system/app.service"

# Creating and writing to the service file
{
    echo "[Unit]"
    echo "Description=Start $user app"
    echo ""
    echo "[Service]"
    echo "ExecStart=$venv_path $app_script"
    echo "Restart=always"
    echo ""
    echo "[Install]"
    echo "WantedBy=multi-user.target"
} > "$service_file" || die "Failed to create service file: $service_file"

# Enabling the service
echo "Enabling app.service"
systemctl enable app.service || die "Failed to enable app.service"

echo "App service initialized"

exit 0
