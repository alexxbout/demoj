#!/bin/bash
# shellcheck shell=bash source=/dev/null disable=SC2154

: '
This script runs all the scripts in the others directory.
'

# Including utility functions
source "$(dirname "$0")"/utils.sh

# Checking if the script is executed as root
check_root

# Displaying initialization message
echo "Running all scripts"

# Get the user
user="$SUDO_USER"
nbScripts=0
nbScriptsExecuted=0

if [ "$user" = "network" ]; then
    nbScripts=8
elif [ "$user" = "terminal" ]; then
    nbScripts=6
elif [ "$user" = "server" ]; then
    nbScripts=8
fi

# Executing scripts based on the user
"./others/raspios.sh" || die "Failed to execute raspios.sh"
nbScriptsExecuted=$((nbScriptsExecuted + 1))
echo -e "${GREEN}$nbScriptsExecuted/$nbScripts${RESET} scripts executed"

"./others/sudoers.sh" "$user" || die "Failed to execute sudoers.sh"
nbScriptsExecuted=$((nbScriptsExecuted + 1))
echo -e "${GREEN}$nbScriptsExecuted/$nbScripts${RESET} scripts executed"

"./others/repository.sh" "$user" || die "Failed to execute repository.sh"
nbScriptsExecuted=$((nbScriptsExecuted + 1))
echo -e "${GREEN}$nbScriptsExecuted/$nbScripts${RESET} scripts executed"

"./others/virtualenv.sh" "$user" || die "Failed to execute virtualenv.sh"
nbScriptsExecuted=$((nbScriptsExecuted + 1))
echo -e "${GREEN}$nbScriptsExecuted/$nbScripts${RESET} scripts executed"

"./others/appservice.sh" "$user" || die "Failed to execute appservice.sh"
nbScriptsExecuted=$((nbScriptsExecuted + 1))
echo -e "${GREEN}$nbScriptsExecuted/$nbScripts${RESET} scripts executed"

if [ "$user" = "network" ]; then
    "./others/demojconnect.sh" || die "Failed to execute demojconnect.sh"
    nbScriptsExecuted=$((nbScriptsExecuted + 1))
    echo -e "${GREEN}$nbScriptsExecuted/$nbScripts${RESET} scripts executed"
    
    "./others/raspap.sh" || die "Failed to execute raspap.sh"
    nbScriptsExecuted=$((nbScriptsExecuted + 1))
    echo -e "${GREEN}$nbScriptsExecuted/$nbScripts${RESET} scripts executed"

    "./others/dns.sh" || die "Failed to execute dns.sh"
    nbScriptsExecuted=$((nbScriptsExecuted + 1))
    echo -e "${GREEN}$nbScriptsExecuted/$nbScripts${RESET} scripts executed"
elif [ "$user" = "server" ]; then
    "./others/wifi.sh" || die "Failed to execute wifi.sh"
    nbScriptsExecuted=$((nbScriptsExecuted + 1))
    echo -e "${GREEN}$nbScriptsExecuted/$nbScripts${RESET} scripts executed"

    "./others/scenariosapp.sh" || die "Failed to execute scenariosapp.sh"
    nbScriptsExecuted=$((nbScriptsExecuted + 1))
    echo -e "${GREEN}$nbScriptsExecuted/$nbScripts${RESET} scripts executed"

    "./others/ollama.sh" || die "Failed to execute ollama.sh"
    nbScriptsExecuted=$((nbScriptsExecuted + 1))
    echo -e "${GREEN}$nbScriptsExecuted/$nbScripts${RESET} scripts executed"
else
    "./others/wifi.sh" || die "Failed to execute wifi.sh"
    nbScriptsExecuted=$((nbScriptsExecuted + 1))
    echo -e "${GREEN}$nbScriptsExecuted/$nbScripts${RESET} scripts executed"
fi

echo -e "${GREEN}Setup complete. Have fun with DemoJ! ${RESET}";

exit 0
