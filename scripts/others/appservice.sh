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
service_name="app.service"
venv_path="/home/$user/demoj/venv/bin/python3"
app_script="/home/$user/demoj/module/scripts/app.py"
file="/etc/systemd/system/$service_name"

echo "Initializing app service"

echo "Creating default service file"
# Creating and writing to the service file
cat <<EOL >"$file"
[Unit]
Description=Start $user app service

[Service]
ExecStart=$venv_path $app_script
Restart=always

[Install]
WantedBy=multi-user.target
EOL

# Enabling the service
echo "Enabling $service_name"
systemctl enable $service_name >> "$log_file" 2>&1 || die "Failed to enable $service_name"

# Starting the service
echo "Starting $service_name"
systemctl start $service_name >> "$log_file" 2>&1 || die "Failed to start $service_name"

# If we are on server, we need to add an extra service to start server.py
if [ "$user" == "server" ] || [ "$user" == "network" ]; then
    echo "Creating server service file"
    server_service_name="server.service"
    server_script="/home/$user/demoj/module/scripts/server.py"
    server_file="/etc/systemd/system/$server_service_name"

    # Creating and writing to the service file
    cat <<EOL >"$server_file"
    [Unit]
    Description=Start $user server service

    [Service]
    ExecStart=$venv_path $server_script
    Restart=always

    [Install]
    WantedBy=multi-user.target
EOL

    # Enabling the service
    echo "Enabling $server_service_name"
    systemctl enable $server_service_name >> "$log_file" 2>&1 || die "Failed to enable $server_service_name"

    # Starting the service
    echo "Starting $server_service_name"
    systemctl start $server_service_name >> "$log_file" 2>&1 || die "Failed to start $server_service_name"
fi

echo -e "${GREEN}App service initialized ${RESET}"

exit 0