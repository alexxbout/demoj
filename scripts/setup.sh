#!/bin/bash
# shellcheck shell=bash source=/dev/null

# Including utility functions
source "$(dirname "$0")"/others/utils.sh

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

clear

echo "Welcome to the DemoJ setup script!"
echo "Installing dependencies for the DemoJ project."
echo "Ensure SSH connection to the target device with internet access."
echo ""
echo "Please select the user you want to install the project for."
echo "  1. Terminal"
echo "  2. Network"
echo "  3. Server"
echo "  4. Continue anyway"
echo ""

while true; do
  read -rp "Enter your choice: " user

  if [ "$user" == "1" ]; then
    user="terminal"
    break
  elif [ "$user" == "2" ]; then
    user="network"
    break
  elif [ "$user" == "3" ]; then
    user="server"
    break
  elif [ "$user" == "4" ]; then
    user="unknown"
    echo "Warning: User set to unknown. Some features may not be available."
    break
  else
    echo "Invalid option. Please try again."
  fi
done

clear

echo "User set to $user"
echo ""

echo "Please select the options you want to install."

echo "  1. Install DemoJ on this device"
echo ""
echo "Other options:"
echo "  2. Run appservice"
echo "  3. Run raspap"
echo "  4. Run repository"
echo "  5. Run staticip"
echo "  6. Run sudoers"
echo "  7. Run virtualenv"
echo ""
echo "  0. Exit"
echo ""

while true; do
  read -rp "Enter your choice: " choice

  case $choice in
  1)
    echo "Running all..."
    "others/runall.sh" "$user"

    echo "Setup complete. Have fun with DemoJ!"
    break
    ;;
  2)
    echo "Running appservice..."
    "others/appservice.sh" "$user"
    break
    ;;
  3)
    echo "Running raspap..."
    "others/raspap.sh" "$user"
    break
    ;;
  4)
    echo "Running repository..."
    "others/repository.sh" "$user"
    break
    ;;
  5)
    echo "Running staticip..."
    "others/staticip.sh" "$user"
    break
    ;;
  6)
    echo "Running sudoers..."
    "others/sudoers.sh" "$user"
    break
    ;;
  7)
    echo "Running virtualenv..."
    "others/virtualenv.sh" "$user"
    break
    ;;
  0)
    echo "Exiting..."
    exit 0
    ;;
  *)
    echo "Invalid option. Please try again."
  esac
done

echo ""

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