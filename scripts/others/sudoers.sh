#!/bin/bash
# shellcheck shell=bash source=/dev/null

# Including utility functions
source "$(dirname "$0")"/utils.sh

# Checking if the script is executed as root
check_root

# Displaying initialization message
echo "Initializing sudoers file"

# Retrieving the user
user="$1"

# Checking the validity of the user
valid_users=("terminal" "network" "server")
check_param_in_array "$user" "${valid_users[@]}" || die "Invalid user"

command_line="$user ALL=(ALL) NOPASSWD:"

# Adding reboot and shutdown commands to the sudoers file
if ! grep -q "$command_line /sbin/reboot" /etc/sudoers; then
    echo "Adding reboot command to sudoers file"
    echo "$command_line /sbin/reboot" >> /etc/sudoers
else
    echo "Reboot command already in sudoers file"
fi

if ! grep -q "$command_line /sbin/shutdown" /etc/sudoers; then
    echo "Adding shutdown command to sudoers file"
    echo "$command_line /sbin/shutdown" >> /etc/sudoers
else
    echo "Shutdown command already in sudoers file"
fi

echo "Sudoers file initialized"

exit 0
