#!/bin/bash
# shellcheck shell=bash source=/dev/null disable=SC2154

# Including utility functions
source "$(dirname "$0")"/utils.sh

# Checking if the script is executed as root
check_root

# Displaying initialization message
echo "Running all scripts"

# Get the user
user="$SUDO_USER"
nbScripts=0

if [ "$user" = "network" ]; then
    nbScripts=7
else
    nbScripts=6
fi

# Executing scripts based on the user
"./others/raspios.sh" || die "Failed to execute raspios.sh"
echo -e "${GREEN}1/$nbScripts${RESET} scripts executed"

"./others/sudoers.sh" "$user" || die "Failed to execute sudoers.sh"
echo -e "${GREEN}2/$nbScripts${RESET} scripts executed"

"./others/repository.sh" "$user" || die "Failed to execute repository.sh"
echo -e "${GREEN}3/$nbScripts${RESET} scripts executed"

"./others/virtualenv.sh" "$user" || die "Failed to execute virtualenv.sh"
echo -e "${GREEN}4/$nbScripts${RESET} scripts executed"

if [ "$user" = "network" ]; then
    "./others/demojconnect.sh" || die "Failed to execute demojconnect.sh"
    echo -e "${GREEN}5/$nbScripts${RESET} scripts executed"
    
    "./others/raspap.sh" || die "Failed to execute raspap.sh"
    echo -e "${GREEN}6/$nbScripts${RESET} scripts executed"
else
    "./others/staticip.sh" "$user" || die "Failed to execute staticip.sh"
    echo -e "${GREEN}5/$nbScripts${RESET} scripts executed"
fi

"./others/appservice.sh" "$user" || die "Failed to execute appservice.sh"
echo -e "${GREEN}$nbScripts/$nbScripts${RESET} scripts executed"

echo -e "${GREEN}Setup complete. Have fun with DemoJ! ${RESET}";

exit 0
