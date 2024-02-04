#!/usr/bin/sudo bash
# shellcheck shell=bash

# args: user

echo "Initializing app service"

user=$1

if [ "$user" != "terminal" ] && [ "$user" != "network" ] && [ "$user" != "server" ]; then
    echo "Invalid user"
    exit 1
fi

echo "Creating app.service file"

file="/etc/systemd/system/app.service"

{
    echo "[Unit]"
    echo "Description=Start $user app"
    echo ""
    echo "[Service]"
    echo "ExecStart=/home/$user/demoj/venv/bin/python3 /home/$user/demoj/module/scripts/app.py"
    echo "Restart=always"
    echo ""
    echo "[Install]"
    echo "WantedBy=multi-user.target"
} > $file

echo "Enabling app.service"
sudo systemctl enable app.service

echo "App service initialized"

exit 0