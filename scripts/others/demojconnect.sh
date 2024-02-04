#!/usr/bin/sudo bash
# shellcheck shell=bash

echo "Initialising Demoj Connect"

if [ ! -d "$dir" ]; then
    echo "Directory /home/network/demoj does not exist. Please run repository.sh first"
    exit 1
fi

dir="/home/network/demoj"

cd "$dir" || exit 1

sudo -u network git checkout demojconnect

cd "demoj-app" || exit 1

if ! command -v node &> /dev/null; then
    echo "Node is not installed"

    apt install nodejs

    if ! command -v node &> /dev/null; then
        echo "Node installation failed"
        exit 1
    fi

    echo "Node installed"
fi

if ! command -v npm &> /dev/null; then
    echo "Npm is not installed"

    apt install npm

    if ! command -v npm &> /dev/null; then
        echo "Npm installation failed"
        exit 1
    fi

    echo "Npm installed"
fi

echo "Installing dependencies"

npm install

echo "Building app"

ionic build

echo "App built"
echo "Moving app to /home/network/temp"

if [ ! -d "/home/network/temp" ]; then
    mkdir /home/network/temp
fi

mv /home/network/demoj/demoj-app/demojconnect /home/network/temp

echo "App moved to /home/network/temp"

rm -rf /home/network/demoj/demoj-app/demojconnect

echo "Switching to network branch"

cd "$dir" || exit 1

sudo -u network git checkout network

echo "Moving app to /home/network/demoj/module"

mv /home/network/temp/demojconnect /home/network/demoj/module

echo "App moved to /home/network/demoj/module"

echo "DemoJ Connect initialised"

exit 0