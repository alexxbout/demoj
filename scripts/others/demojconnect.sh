#!/usr/bin/sudo bash
# shellcheck shell=bash

echo "Initializing Demoj Connect"

dir="/home/network/demoj"

if [ ! -d "$dir" ]; then
    echo "Directory $dir does not exist. Please run repository.sh first"
    exit 1
fi

cd "$dir" || exit 1

sudo -u network git checkout demojconnect || exit 1

cd "demoj-app" || exit 1

if ! command -v node &> /dev/null; then
    echo "Node is not installed"
    apt install nodejs -y || exit 1

    if ! command -v node &> /dev/null; then
        echo "Node installation failed"
        exit 1
    fi

    echo "Node installed"
fi

if ! command -v npm &> /dev/null; then
    echo "Npm is not installed"
    apt install npm -y || exit 1

    if ! command -v npm &> /dev/null; then
        echo "Npm installation failed"
        exit 1
    fi

    echo "Npm installed"
fi

echo "Installing dependencies"
npm install || exit 1

echo "Building app"
ionic build || exit 1

echo "App built"
echo "Moving app to /home/network/temp"

temp_dir="/home/network/temp"

if [ ! -d "$temp_dir" ]; then
    mkdir "$temp_dir" || exit 1
fi

mv "$dir/demoj-app/demojconnect" "$temp_dir" || exit 1

echo "App moved to $temp_dir"

echo "Switching to network branch"

cd "$dir" || exit 1

sudo -u network git checkout network || exit 1

echo "Moving app to /home/network/demoj/module"
mv "$temp_dir/demojconnect" "$dir/module" || exit 1

echo "App moved to $dir/module"

echo "DemoJ Connect initialized"
exit 0