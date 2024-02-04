#!/usr/bin/sudo bash
# shellcheck shell=bash

# args: user

echo "Initializing sudoers file"

user=$1
command_line="$user ALL=(ALL) NOPASSWD:"

if [ "$user" != "terminal" ] && [ "$user" != "network" ] && [ "$user" != "server" ]; then
    echo "Invalid user"
    exit 1
fi

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