#!/bin/bash
# shellcheck shell=bash source=/dev/null disable=SC2154

: '
This script downloads a video from a URL and saves it to the working directory.
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

# Displaying initialization message
echo "Initializing streaming application"

# Defining working directory
dir="/home/$user/demoj"

# Checking if directory exists
check_directory "$dir" >> "$log_file" 2>&1 || die "Directory $dir does not exist"

# Create videos directory
mkdir -p "$dir/videos" >> "$log_file" 2>&1 || die "Failed to create videos directory"

# Changing directory to working directory
cd "$dir" >> "$log_file" 2>&1 || die "Failed to change directory to $dir"

# Finalization message
echo -e "${GREEN}Streaming application initialized ${RESET}"
exit 0
