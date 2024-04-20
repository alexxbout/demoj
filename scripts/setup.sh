#!/bin/bash
# shellcheck shell=bash source=/dev/null
# shellcheck disable=SC2034

# Including utility functions
source "$(dirname "$0")"/others/utils.sh

user="$SUDO_USER"

# Check if the script is run as root
check_root

# Check if ping is installed, if not, install it
if ! [ -x "$(command -v ping)" ]; then
  echo "Installing ping"
  apt install inetutils-ping -y
fi

# Check if internet connection is available
if ! ping -q -c 1 -W 1 google.com >/dev/null; then
  echo -e "${RED}Internet is not available. Please connect to the internet and try again. ${RESET}"
  exit 1
fi

# Check if .logs.txt exists, if not, create it else clear it
if [ ! -f .logs.txt ]; then
  touch .logs.txt
else
  truncate -s 0 .logs.txt
fi

# Set executable permissions for all scripts in the others directory
chmod +x others/*.sh

clear

echo -e "${GREEN}Welcome to the DemoJ setup script! ${RESET}"
echo "Installing dependencies for the DemoJ project."
echo "Ensure SSH connection to the target device with internet access."
echo

# Afficher les options disponibles
echo -e "${ORANGE}Please select the options you want to install: ${RESET}"
options=("Install DemoJ on this device" "Run appservice" "Run repository" "Run sudoers" "Run virtualenv" "Run raspap" "Run raspios" "Run demojconnect" "Run wifi" "Run dns" "Exit")
select install_option in "${options[@]}"; do
    case $REPLY in
        1) "others/runall.sh" "$user"; break;;
        2) "others/appservice.sh" "$user"; break;;
        3) "others/repository.sh" "$user"; break;;
        4) "others/sudoers.sh" "$user"; break;;
        5) "others/virtualenv.sh" "$user"; break;;
        6) "others/raspap.sh"; break;;
        7) "others/raspios.sh"; break;;
        8) "others/demojconnect.sh"; break;;
        9) "others/wifi.sh"; break;;
        10) "others/dns.sh"; break;;
        11) echo "Exiting..."; exit 0;;
        *) echo -e "${RED}Invalid option. Please try again. ${RESET}";;
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
    echo -e "${RED}Invalid response. Please try again. ${RESET}"
  esac
done