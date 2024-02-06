#!/bin/bash
# shellcheck shell=bash

# Affichage du message d'initialisation
echo "Initializing raspios"

# Mise à jour du système
echo "Updating system"
apt update -y
apt -y full-upgrade

# Installation de pip
echo "Installing pip"
apt install python3-pip -y

# Installation de venv
echo "Installing venv"
apt install python3.11-venv -y

# Installation de build-essential
echo "Installing build-essential"
apt install build-essential -y

# Installation du paquet smbus via pip
echo "Installing smbus"
pip3 install smbus --break-system-packages

# Installation du paquet rpi_ws281x via pip
echo "Installing strip led API"
pip3 install rpi_ws281x --break-system-packages

# Configuration de l'I2C
echo "Setup I2C"
if [ "$(raspi-config nonint get_i2c)" -eq 0 ]
then
    echo "I2C already enabled"
else
    raspi-config nonint do_i2c 0
    echo "I2C enabled"
fi

# Fin de l'initialisation de Raspios
echo "Raspios initialized"

exit 0