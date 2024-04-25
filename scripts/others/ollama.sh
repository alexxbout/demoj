#!/bin/bash
# shellcheck shell=bash source=/dev/null disable=SC2154

# ! NEED TO BE TESTED
# ! Problem just after the install, ollama command not found, added systemctl start but need to be tested

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

systemctl start ollama >> "$log_file" 2>&1 || die "Failed to start Ollama"

ollama pull "$model" >> "$log_file" 2>&1 || die "Failed to pull $model"

echo -e "${GREEN}Successfully installed Ollama ${RESET}"
exit 0