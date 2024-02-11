#!/bin/bash
# shellcheck shell=bash source=/dev/null
# shellcheck disable=SC2034

# Including utility functions
source "$(dirname "$0")"/others/utils.sh

# Fonction pour demander à l'utilisateur de sélectionner un utilisateur
select_user() {
    clear
    echo "Please select the user you want to install the project for:"
    options=("Terminal" "Network" "Server")
    select user_option in "${options[@]}"; do
        case $REPLY in
            1) echo "terminal"; break;;
            2) echo "network"; break;;
            3) echo "server"; break;;
            *) echo "Invalid option. Please try again.";;
        esac
    done
}

# Check if the script is run as root
check_root

# Check if ping is installed, if not, install it
if ! [ -x "$(command -v ping)" ]; then
  echo "Installing ping"
  apt install inetutils-ping -y
fi

# Check if internet connection is available
if ! ping -q -c 1 -W 1 google.com >/dev/null; then
  echo "Internet is not available. Please connect to the internet and try again."
  exit 1
fi

# Set executable permissions for other scripts
chmod +x others/appservice.sh
chmod +x others/raspap.sh
chmod +x others/raspios.sh
chmod +x others/repository.sh
chmod +x others/runall.sh
chmod +x others/staticip.sh
chmod +x others/sudoers.sh
chmod +x others/virtualenv.sh
chmod +x others/demojconnect.sh

clear

echo "Welcome to the DemoJ setup script!"
echo "Installing dependencies for the DemoJ project."
echo "Ensure SSH connection to the target device with internet access."
echo

# Afficher les options disponibles
echo "Please select the options you want to install:"
options=("Install DemoJ on this device" "Run appservice" "Run repository" "Run sudoers" "Run virtualenv" "Run raspap" "Run staticip" "Run raspios" "Run demojconnect" "Exit")
select install_option in "${options[@]}"; do
    case $REPLY in
        1) user=$(select_user); "others/runall.sh" "$user"; echo "Setup complete. Have fun with DemoJ!"; break;;
        2) user=$(select_user); "others/appservice.sh" "$user"; break;;
        3) user=$(select_user); "others/repository.sh" "$user"; break;;
        4) user=$(select_user); "others/sudoers.sh" "$user"; break;;
        5) user=$(select_user); "others/virtualenv.sh" "$user"; break;;
        6) "others/raspap.sh"; break;;
        7) "others/staticip.sh"; break;;
        8) "others/raspios.sh"; break;;
        9) "others/demojconnect.sh"; break;;
        10) echo "Exiting..."; exit 0;;
        *) echo "Invalid option. Please try again.";;
    esac
done

echo

while true; do
  read -rp "Do you want to reboot now? (y/n) " yn
  case $yn in
  [yY])
    echo "Rebooting..."
    reboot
    ;;
  [nN])
    echo "Exiting..."
    exit 0
    ;;
  *)
    echo "Invalid response. Please try again."
  esac
done