#!/bin/bash
# shellcheck shell=bash source=/dev/null disable=SC2154

# ! NEED TO BE TESTED

: '
This script downloads and installs Ollama.
'

# Including utility functions
source "$(dirname "$0")"/utils.sh

# Checking if the script is executed as root
check_root

user="$SUDO_USER"

if [ "$user" != "server" ]; then
    echo "User is not server"
    exit 1
fi

model="phi"

# Displaying initialization message
echo "Initializing Ollama"

curl -fsSL https://ollama.com/install.sh | sh >> "$log_file" 2>&1 || die "Failed to install Ollama"

sed -i '/\[Service\]/a Environment="OLLAMA_HOST=0.0.0.0"' /etc/systemd/system/ollama.service
sed -i '/\[Service\]/a Environment="OLLAMA_ORIGINS=*"' /etc/systemd/system/ollama.service

# Starting the service
echo "Starting Ollama"
systemctl start ollama >> "$log_file" 2>&1 || die "Failed to start Ollama"

# Pulling the model
echo "Pulling the model"
ollama pull "$model" >> "$log_file" 2>&1 || die "Failed to pull $model"



echo -e "${GREEN}Successfully installed Ollama ${RESET}"
exit 0