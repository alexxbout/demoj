#!/usr/bin/sudo bash

# args: user

echo "Initialising sudoers file"

if [ -z "$1" ]; then
    echo "User not set"
    exit 1
fi

command_line="$1 ALL=(ALL) NOPASSWD:"

if ! grep -q "$command_line /sbin/reboot" /etc/sudoers; then
    echo "$command_line /sbin/reboot" >> /etc/sudoers
fi

if ! grep -q "$command_line /sbin/shutdown" /etc/sudoers; then
    echo "$command_line /sbin/shutdown" >> /etc/sudoers
fi

echo "Sudoers file initialised"