#!/bin/bash
# shellcheck shell=bash

# Affichage du message d'initialisation
echo "Initializing Demoj Connect"

# Définition du répertoire de travail
dir="/home/network/demoj"

# Vérification de l'existence du répertoire
if [ ! -d "$dir" ]; then
    echo "Directory $dir does not exist. Please run repository.sh first"
    exit 1
fi

# Changement de répertoire vers le répertoire de travail
cd "$dir" || exit 1

# Mise à jour du code depuis le dépôt Git
sudo -u network git checkout demojconnect || exit 1

# Changement de répertoire vers le répertoire de l'application
cd "demoj-app" || exit 1

# Vérification de l'installation de Node.js
if ! command -v node &> /dev/null; then
    echo "Node is not installed"
    apt install nodejs -y || exit 1

    if ! command -v node &> /dev/null; then
        echo "Node installation failed"
        exit 1
    fi

    echo "Node installed"
fi

# Vérification de l'installation de npm
if ! command -v npm &> /dev/null; then
    echo "Npm is not installed"
    apt install npm -y || exit 1

    if ! command -v npm &> /dev/null; then
        echo "Npm installation failed"
        exit 1
    fi

    echo "Npm installed"
fi

# Installation des dépendances de l'application
echo "Installing dependencies"
npm install || exit 1

# Construction de l'application
echo "Building app"
ionic build || exit 1

echo "App built"
echo "Moving app to /home/network/temp"

# Définition du répertoire temporaire
temp_dir="/home/network/temp"

# Création du répertoire temporaire s'il n'existe pas
if [ ! -d "$temp_dir" ]; then
    mkdir "$temp_dir" || exit 1
fi

# Déplacement de l'application vers le répertoire temporaire
mv "$dir/demoj-app/demojconnect" "$temp_dir" || exit 1

echo "App moved to $temp_dir"

# Changement de branche Git
echo "Switching to network branch"
cd "$dir" || exit 1
sudo -u network git checkout network || exit 1

# Déplacement de l'application vers le répertoire final
echo "Moving app to /home/network/demoj/module"
mv "$temp_dir/demojconnect" "$dir/module" || exit 1

echo "App moved to $dir/module"

# Message de finalisation
echo "DemoJ Connect initialized"
exit 0