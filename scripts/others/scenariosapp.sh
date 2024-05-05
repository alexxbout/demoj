#!/bin/bash
# shellcheck shell=bash source=/dev/null disable=SC2154

: '
This script initializes the scenario application.
The application is built and moved to the final directory.
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
echo "Initializing scenario application"

# Defining working directory
dir="/home/$user/demoj"

# Checking if directory exists
check_directory "$dir" >> "$log_file" 2>&1 || die "Directory $dir does not exist"

# Changing directory to working directory
cd "$dir" >> "$log_file" 2>&1 || die "Failed to change directory to $dir"

# Updating code from Git repository
if sudo -u "$user" git checkout scenarios; then
    echo "Switched to scenarios branch"
else
    die "Failed to switch to scenarios branch"
fi

# Changing directory to application directory
cd "scenarios-app" >> "$log_file" 2>&1 || die "Failed to change directory to scenarios-app"

# Checking if Node.js and npm are installed
if ! command -v node &> /dev/null || ! command -v npm &> /dev/null; then
    echo "Node.js or npm is not installed, installing..."
    apt install nodejs npm -y >> "$log_file" 2>&1 || die "Failed to install Node.js and npm"
    echo "Node.js and npm installed"
fi

# Installing application dependencies
echo "Installing dependencies"
npm install >> "$log_file" 2>&1 || die "Failed to install dependencies"

# Building the application
echo "Building app"
npm run build >> "$log_file" 2>&1 || die "Failed to build app"

# Defining temporary directory
tmp_dir="/home/$user/tmp"

echo "Moving app to $tmp_dir"

# Creating temporary directory if it doesn't exist
mkdir -p "$tmp_dir" >> "$log_file" 2>&1 || die "Failed to create tmp directory: $tmp_dir"

# Moving the application to the temporary directory
mv "$dir/scenarios-app/dist" "$tmp_dir" >> "$log_file" 2>&1 || die "Failed to move app to $tmp_dir"

# Changing Git branch
echo "Switching to $user branch"
cd "$dir" >> "$log_file" 2>&1 || die "Failed to change directory to $dir"
if sudo -u "$user" git checkout "$user"; then
    echo "Switched to $user branch"
else
    die "Failed to switch to $user branch"
fi

# Moving the application to the final directory
echo "Moving app to /home/$user/demoj/module"
mv "$tmp_dir/dist" "$dir/module/scripts" >> "$log_file" 2>&1 || die "Failed to move app to $dir/module"

# Finalization message
echo -e "${GREEN}Scenario application initialized ${RESET}"
exit 0
