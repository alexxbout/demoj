#!/bin/bash
# shellcheck shell=bash source=/dev/null disable=SC2154

: '
This script initializes the sudoers file for the demoj project.
The script adds the reboot and shutdown commands to the sudoers file.
'

# Including utility functions
source "$(dirname "$0")"/utils.sh

# Checking if the script is executed as root
check_root

# Displaying initialization message
echo "Initializing sudoers file"

# Get the user
user="$SUDO_USER"

command_line="$user ALL=(ALL) NOPASSWD:"

# Creating a backup of /etc/sudoers if the backup file doesn't exist
file="/etc/sudoers"
echo "Creating backup of $file"
create_bak "$file" || die "Failed to create backup of $file"

# Adding reboot and shutdown commands to the sudoers file
if ! grep -q "$command_line /sbin/reboot" "$file"; then
    echo "Adding reboot command to sudoers file"
    echo "$command_line /sbin/reboot" >> "$file"
else
    echo "Reboot command already in sudoers file"
fi

if ! grep -q "$command_line /sbin/shutdown" "$file"; then
    echo "Adding shutdown command to sudoers file"
    echo "$command_line /sbin/shutdown" >> "$file"
else
    echo "Shutdown command already in sudoers file"
fi

echo -e "${GREEN}Sudoers file initialized ${RESET}"

exit 0
