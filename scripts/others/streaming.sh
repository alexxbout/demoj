#!/bin/bash
# shellcheck shell=bash source=/dev/null disable=SC2154

# ! NEED TO BE TESTED

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

# Downloading video
echo "Downloading video"
wget -O "videos/low.mp4" "https://www.pexels.com/download/video/4193130/?fps=23.976&h=240&w=426" >> "$log_file" 2>&1 || die "Failed to download video"

# Finalization message
echo -e "${GREEN}Streaming application initialized ${RESET}"
exit 0
