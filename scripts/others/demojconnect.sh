#!/bin/bash
# shellcheck shell=bash source=/dev/null

# Including utility functions
source "$(dirname "$0")"/utils.sh

# Redirecting output to log file
redirect_output

# Displaying initialization message
echo "Initializing Demoj Connect"

# Defining working directory
dir="/home/network/demoj"

# Checking if directory exists
check_directory "$dir"

# Changing directory to working directory
cd "$dir" || die "Failed to change directory to $dir"

# Updating code from Git repository
sudo -u network git checkout demojconnect || die "Failed to checkout demojconnect"

# Changing directory to application directory
cd "demoj-app" || die "Failed to change directory to demoj-app"

# Checking if Node.js and npm are installed
if ! command -v node &> /dev/null || ! command -v npm &> /dev/null; then
    echo "Node.js or npm is not installed, installing..."
    apt install nodejs npm -y || die "Failed to install Node.js and npm"
    echo "Node.js and npm installed"
fi

# Installing application dependencies
echo "Installing dependencies"
npm i -g @ionic/cli || die "Failed to install Ionic CLI"
npm install || die "Failed to install dependencies"

# Building the application
echo "Building app"
ionic build || die "Failed to build app"

echo "App built"
echo "Moving app to /home/network/temp"

# Defining temporary directory
temp_dir="/home/network/temp"

# Creating temporary directory if it doesn't exist
mkdir -p "$temp_dir" || die "Failed to create temp directory: $temp_dir"

# Moving the application to the temporary directory
mv "$dir/demoj-app/demojconnect" "$temp_dir" || die "Failed to move app to $temp_dir"

echo "App moved to $temp_dir"

# Changing Git branch
echo "Switching to network branch"
cd "$dir" || die "Failed to change directory to $dir"
sudo -u network git checkout network || die "Failed to checkout network branch"

# Moving the application to the final directory
echo "Moving app to /home/network/demoj/module"
mv "$temp_dir/demojconnect" "$dir/module" || die "Failed to move app to $dir/module"

echo "App moved to $dir/module"

# Finalization message
echo "DemoJ Connect initialized"
exit 0
