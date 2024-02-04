#!/usr/bin/sudo bash
# shellcheck shell=bash

# args: user

echo "Running all scripts"

user=$1

if [ -z "$user" ]; then
    echo "User not set"
    exit 1
fi

"./others/sudoers.sh" "$user"
"./others/repository.sh" "$user"
"./others/virtualenv.sh" "$user"

if [ "$user" = "network" ]; then
    "./others/demojconnect.sh"
    "./others/raspap.sh"
else
    "./others/staticip.sh" "$user"
fi

"./others/appservice.sh" "$user"

echo "All scripts run"

exit 0