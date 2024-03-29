#!/bin/bash
# shellcheck shell=bash disable=SC2154

log_file="../.logs.txt"

die() {
    echo "$1"
    echo "Something went wrong. Do you want to see the logs? (y/n)"
    read -r answer
    if [ "$answer" = "y" ]; then
        cat "$log_file"
    fi

    exit 1
}

check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "Please run this script as root"

        # No return here because the script should exit
        exit 1
    fi
}

check_param_in_array() {
    local param="$1"
    shift
    local param_array=("$@")

    for p in "${param_array[@]}"; do
        if [ "$param" = "$p" ]; then
            return 0
        fi
    done

    return 1
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
    fi

    return 1
}