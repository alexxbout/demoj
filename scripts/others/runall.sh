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

if [ "$user" = "network" ]; then
    nbScripts=7
elif [ "$user" = "terminal" ]; then
    nbScripts=7
elif [ "$user" = "server" ]; then
    nbScripts=7
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

"./others/appservice.sh" "$user" || die "Failed to execute appservice.sh"
echo -e "${GREEN}5/$nbScripts${RESET} scripts executed"

if [ "$user" = "network" ]; then
    "./others/demojconnect.sh" || die "Failed to execute demojconnect.sh"
    echo -e "${GREEN}6/$nbScripts${RESET} scripts executed"
    
    "./others/raspap.sh" || die "Failed to execute raspap.sh"
    echo -e "${GREEN}7/$nbScripts${RESET} scripts executed"
else
    # ! Removed this script temporarily to avoid static IP conflicts
    # "./others/staticip.sh" "$user" || die "Failed to execute staticip.sh"
    # echo -e "${GREEN}6/$nbScripts${RESET} scripts executed"

    "./others/wifi.sh" || die "Failed to execute wifi.sh"
    echo -e "${GREEN}6/$nbScripts${RESET} scripts executed"

    # TODO: Add a case for the server to build apps
fi

echo -e "${GREEN}Setup complete. Have fun with DemoJ! ${RESET}";

exit 0
