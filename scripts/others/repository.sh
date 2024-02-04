#!/usr/bin/sudo bash
# shellcheck shell=bash

# args: user=terminal | network | server

echo "Initializing repo"

user=$1
access_token="glpat-yskhYMsdxsxV4VbFrz2M"
repo="https://demoj:$access_token@gitlab.istic.univ-rennes1.fr/arthadam/demoj.git"
clone_dir="/home/$user/demoj"

if [ "$user" != "terminal" ] && [ "$user" != "network" ] && [ "$user" != "server" ]; then
    echo "Invalid user"
    exit 1
fi

if ! command -v git &> /dev/null
then
    echo "Git is not installed"
    
    echo "Installing git"
    apt install git -y
fi

echo "Cloning repo"

if [ ! -d "$clone_dir" ]; then
    mkdir "$clone_dir"
    chown "$user":"$user" "$clone_dir"
fi

if sudo -u "$user" git clone "$repo" "$clone_dir"; then
    echo "Repo cloned"
else
    echo "Failed to clone repo"
    exit 1
fi

echo "Switching to $user branch"

cd "$clone_dir" || exit 1

if ! sudo -u "$user" git checkout "$user"; then
    echo "Failed to switch to $user branch"
    exit 1
fi

echo "Repo initialized"

exit 0