#!/usr/bin/sudo bash
# shellcheck shell=bash
# shellcheck disable=SC1091

# TODO: Add other dependencies here if needed

echo "Initialising virtualenv"

user=$1

if [ -z "$user" ]; then
    echo "User not set"
    exit 1
fi

if [ "$user" != "terminal" ] && [ "$user" != "network" ] && [ "$user" != "server" ]; then
    echo "Invalid user"
    exit 1
fi

if [ ! -d "/home/$user/demoj" ]; then
    echo "Directory /home/$user/demoj does not exist. Please run repository.sh first"
    exit 1
fi

apt install python3.11-venv -y

cd "/home/$user/demoj" || exit 1

source venv/bin/activate

if [ "$user" = "terminal" ] || [ "$user" = "server" ]; then
    pip install "python-socketio[client]"
elif [ "$user" = "network" ]; then
    pip install flask
    pip install flask_cors
    pip install flask-socketio
fi

deactivate

echo "Virtualenv initialised"

exit 0