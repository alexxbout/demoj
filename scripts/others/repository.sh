#!/bin/bash
# shellcheck shell=bash source=/dev/null

# Include utility functions
source "$(dirname "$0")"/utils.sh

# Check if the script is executed as root
check_root

# Display initialization message
echo "Initializing repo"

# Get the user from the arguments
user="$1"

# Check the validity of the user
valid_users=("terminal" "network" "server")
check_param_in_array "$user" "${valid_users[@]}" || die "Invalid user"

# Define constants
readonly access_token="glpat-yskhYMsdxsxV4VbFrz2M"
readonly gitlab_url="gitlab.istic.univ-rennes1.fr"
readonly repo_path="/arthadam/demoj.git"
readonly repo="https://demoj:$access_token@$gitlab_url$repo_path"
readonly clone_dir="/home/$user/demoj"

# Check if Git is installed
if ! command -v git &> /dev/null; then
    echo "Installing git"
    apt install git -y || die "Failed to install git"
fi

# Clone the Git repository to the specified directory
echo "Cloning repo"
if [ ! -d "$clone_dir" ]; then
    mkdir -p "$clone_dir" || die "Failed to create directory $clone_dir"
    chown "$user":"$user" "$clone_dir" || die "Failed to set ownership for $clone_dir"
fi

if sudo -u "$user" git clone "$repo" "$clone_dir"; then
    echo "Repo cloned"
else
    die "Failed to clone repo"
fi

# Switch to the user's branch
echo "Switching to $user branch"
cd "$clone_dir" || die "Failed to change directory to $clone_dir"
if ! sudo -u "$user" git checkout "$user"; then
    die "Failed to switch to $user branch"
fi

# Finish repository initialization
echo "Repo initialized"
exit 0
