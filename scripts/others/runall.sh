#!/bin/bash
# shellcheck shell=bash source=/dev/null

# Including utility functions
source "$(dirname "$0")"/utils.sh

# Redirecting output to log file
redirect_output

# Checking if the script is executed as root
check_root

# Displaying initialization message
echo "Running all scripts"

# Retrieving the user from the arguments
user="$1"

# Checking the validity of the user
valid_users=("terminal" "network" "server")
check_param_in_array "$user" "${valid_users[@]}" || die "Invalid user: " "$user"

# Executing scripts based on the user
"./others/raspios.sh" || die "Failed to execute raspios.sh"
"./others/sudoers.sh" "$user" || die "Failed to execute sudoers.sh"
"./others/repository.sh" "$user" || die "Failed to execute repository.sh"
"./others/virtualenv.sh" "$user" || die "Failed to execute virtualenv.sh"

if [ "$user" = "network" ]; then
    "./others/demojconnect.sh" || die "Failed to execute demojconnect.sh"
    "./others/raspap.sh" || die "Failed to execute raspap.sh"
else
    "./others/staticip.sh" "$user" || die "Failed to execute staticip.sh"
fi

"./others/appservice.sh" "$user" || die "Failed to execute appservice.sh"

echo "All scripts run"

exit 0
