#!/bin/bash
# shellcheck shell=bash source=/dev/null disable=SC2154

: '
This script initializes the app service for the demoj project.
The app service runs the app.py script in the virtual environment when the system boots.
'

# Including utility functions
source "$(dirname "$0")"/utils.sh

# Checking if the script is executed as root
check_root

# Get the user
user="$SUDO_USER"

# Defining paths
venv_path="/home/$user/demoj/venv/bin/python3"
app_script="/home/$user/demoj/module/scripts/app.py"
file="/etc/systemd/system/app.service"

# Creating and writing to the service file
cat <<EOL >"$file"
[Unit]
Description=Start $user app

[Service]
ExecStart=$venv_path $app_script
Restart=always

[Install]
WantedBy=multi-user.target
EOL

# Enabling the service
echo "Enabling app.service"
systemctl enable app.service >> "$log_file" 2>&1 || die "Failed to enable app.service"

echo -e "${GREEN}App service initialized ${RESET}"

exit 0