#!/usr/bin/sudo bash
# shellcheck shell=bash

# args: user

echo "Running all scripts"

user=$1

if [ -z "$user" ]; then
    echo "User not set"
    exit 1
fi

"./others/appservice.sh $user"
"./others/raspap.sh $user"
"./others/repository.sh $user"
"./others/staticip.sh $user"
"./others/sudoers.sh $user"
"./others/virtualenv.sh $user"