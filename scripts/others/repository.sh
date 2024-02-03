#!/usr/bin/sudo bash
# shellcheck shell=bash

# args: user=terminal | network | server

user=$1
gitlab="gitlab.istic.univ-rennes1.fr"
repo="$gitlab:arthadam/demoj.git"

echo "Initialising repo"

if ! command -v git &> /dev/null
then
    echo "Git is not installed"
    
    echo "Installing git"
    apt-get install git -y
fi

if [ -z "$user" ]; then
    echo "User not set"
    exit 1
fi

if [ "$user" != "terminal" ] && [ "$user" != "network" ] && [ "$user" != "server" ]; then
    echo "Invalid user"
    exit 1
fi

echo "User: $user"

while true; do
    read -pr "Do you want to generate a new SSH key? (y/n) " yn
    case $yn in
        [yY] ) echo "Generating new SSH key"
            ssh-keygen -t rsa -b 4096

            echo "SSH key generated"

            echo "Public key:"
            cat /home/"$user"/.ssh/id_rsa.pub
            break;;
        [nN] ) echo "Using existing SSH key"
            break;;
        * ) echo "Invalid response";;
    esac
done

read -pr "Please add the public key to your gitlab account, press enter when done"

echo "Connecting to gitlab"

attempt=1
while true; do
    if sudo -u "$user" ssh -T git@"$gitlab"; then
        echo "Connected to GitLab"
        break
    else
        echo "Failed to connect to GitLab"
        read -pr "Do you want to retry? (y/n) " retry
        case $retry in
            [yY] ) echo "Retrying..."
                attempt=$((attempt+1))
                ;;
            [nN] ) echo "Exiting..."
                exit 1
                ;;
            * ) echo "Invalid response";;
        esac
    fi
done

echo "Cloning repo"

if sudo -u "$user" git clone "$repo" /home/"$user"/; then
    echo "Repo cloned"
else
    echo "Failed to clone repo"
    exit 1
fi

echo "Repo initialised"