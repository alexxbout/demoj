#!/bin/bash
# shellcheck shell=bash

# Vérification des arguments
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <user>"
    exit 1
fi

# Vérification que le script est exécuté en tant que root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root."
    exit 1
fi

# Récupération de l'utilisateur
user=$1

# Vérification de la validité de l'utilisateur
if [ "$user" != "terminal" ] && [ "$user" != "network" ] && [ "$user" != "server" ]; then
    echo "Invalid user"
    exit 1
fi

# Définition des chemins
venv_path="/home/$user/demoj/venv/bin/python3"
app_script="/home/$user/demoj/module/scripts/app.py"
service_file="/etc/systemd/system/app.service"

echo "Initializing app service"

# Création du fichier de service
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
} > "$service_file"

# Activation du service
echo "Enabling app.service"
systemctl enable app.service

echo "App service initialized"

exit 0