#!/bin/bash
# shellcheck shell=bash disable=SC2154,SC2034

: '
This script is a collection of utility functions.
'

log_file="../.logs.txt"

RED="\e[31m"
GREEN="\e[32m"
ORANGE="\e[33m"
RESET="\e[0m"

die() {
    echo "$1"
    echo -e "${RED}Something went wrong.${RESET} Do you want to see the logs? (y/n)"
    read -r answer
    if [ "$answer" = "y" ]; then
        cat "$log_file"
    fi

    exit 1
}

check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}Please run this script as root ${RESET}"

        # No return here because the script should exit
        exit 1
    fi
}

check_directory() {
    local dir="$1"
    if [ ! -d "$dir" ]; then
        return 1
    fi

    return 0
}

create_bak() {
    local file="$1"
    if [ ! -f "$file.bak" ]; then
        cp "$file" "$file.bak"
        return 0
    else
        # create a backup with 1, 2, 3, ... suffix
        i=1
        while [ -f "$file.bak.$i" ]; do
            i=$((i + 1))
        done
        cp "$file" "$file.bak.$i"
        return 0
    fi
}