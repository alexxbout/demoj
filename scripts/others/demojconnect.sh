#!/bin/bash
# shellcheck shell=bash source=/dev/null disable=SC2154

# Including utility functions
source "$(dirname "$0")"/utils.sh

user="$SUDO_USER"

if [ "$user" != "network" ]; then
    echo "User is not network"
    exit 1
fi

# Displaying initialization message
echo "Initializing Demoj Connect"

# Defining working directory
dir="/home/network/demoj"

# Checking if directory exists
check_directory "$dir" >> "$log_file" 2>&1 || die "Directory $dir does not exist"

# Changing directory to working directory
cd "$dir" >> "$log_file" 2>&1 || die "Failed to change directory to $dir"

# Updating code from Git repository
if sudo -u network git checkout demojconnect; then
    echo "Switched to demojconnect branch"
else
    die "Failed to switch to demojconnect branch"
fi

# Changing directory to application directory
cd "demoj-app" >> "$log_file" 2>&1 || die "Failed to change directory to demoj-app"

# Checking if Node.js and npm are installed
if ! command -v node &> /dev/null || ! command -v npm &> /dev/null; then
    echo "Node.js or npm is not installed, installing..."
    apt install nodejs npm -y >> "$log_file" 2>&1 || die "Failed to install Node.js and npm"
    echo "Node.js and npm installed"
fi

# Installing application dependencies
echo "Installing dependencies"
npm i -g @ionic/cli >> "$log_file" 2>&1 || die "Failed to install Ionic CLI"
npm install >> "$log_file" 2>&1 || die "Failed to install dependencies"

# Building the application
echo "Building app"
ionic build >> "$log_file" 2>&1 || die "Failed to build app"

# Defining temporary directory
temp_dir="/home/network/temp"

echo "Moving app to $temp_dir"

# Creating temporary directory if it doesn't exist
mkdir -p "$temp_dir" >> "$log_file" 2>&1 || die "Failed to create temp directory: $temp_dir"

# Moving the application to the temporary directory
mv "$dir/demoj-app/demojconnect" "$temp_dir" >> "$log_file" 2>&1 || die "Failed to move app to $temp_dir"

# Changing Git branch
echo "Switching to network branch"
cd "$dir" >> "$log_file" 2>&1 || die "Failed to change directory to $dir"
if sudo -u network git checkout network; then
    echo "Switched to network branch"
else
    die "Failed to switch to network branch"
fi

# Moving the application to the final directory
echo "Moving app to /home/network/demoj/module"
mv "$temp_dir/demojconnect" "$dir/module" >> "$log_file" 2>&1 || die "Failed to move app to $dir/module"

# Finalization message
echo -e "${GREEN}DemoJ Connect initialized ${RESET}"
exit 0
