#!/usr/bin/sudo bash
# shellcheck shell=bash

# args: user

echo "Initialising app service"

if [ -z "$1" ]; then
    echo "User not set"
    exit 1
fi

user=$1

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

echo "App service initialised"