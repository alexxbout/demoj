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
nb_scripts=0
nb_scripts_executed=0

# Define the scripts to be executed based on the user
declare -A scripts_to_execute=(
    ["network"]="raspios.sh sudoers.sh repository.sh virtualenv.sh appservice.sh demojconnect.sh raspap.sh dns.sh"
    ["terminal"]="raspios.sh sudoers.sh repository.sh virtualenv.sh appservice.sh wifi.sh"
    ["server"]="raspios.sh sudoers.sh repository.sh virtualenv.sh appservice.sh wifi.sh scenariosapp.sh streaming.sh ollama.sh"
)

# Count the total number of scripts to execute
for script in ${scripts_to_execute[$user]}; do
    ((nb_scripts++))
done

# Execute scripts
for script in ${scripts_to_execute[$user]}; do
    "./others/$script" "$user" || die "Failed to execute $script"
    ((nb_scripts_executed++))
    echo -e "${GREEN}$nb_scripts_executed/$nb_scripts${RESET} scripts executed"
done

echo -e "${GREEN}Setup complete. Have fun with DemoJ! ${RESET}";

exit 0