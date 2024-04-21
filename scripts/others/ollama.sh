#!/bin/bash
# shellcheck shell=bash source=/dev/null disable=SC2154

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

model="llama3"

# Displaying initialization message
echo "Initializing Ollama"

curl -fsSL https://ollama.com/install.sh | sh >> "$log_file" 2>&1 || die "Failed to install Ollama"

ollama pull "$model" >> "$log_file" 2>&1 || die "Failed to pull $model"

echo -e "${GREEN}Successfully installed Ollama ${RESET}"
exit 0