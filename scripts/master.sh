#!/usr/bin/sudo bash
# shellcheck shell=bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root."
  exit
fi

clear

echo -e "\033[1;32m                                                                       
█▀▄ █▀▀ █▀▄▀█ █▀█ ░░█
█▄▀ ██▄ █░▀░█ █▄█ █▄█
\033[0m"

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
    break
  fi
done

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
echo "  0. Exit"
echo ""

read -rp "Enter your choice: " choice

case $choice in
1)
  echo "Running all..."
  "./others/runall.sh $user"
  ;;
2)
    echo "Running appservice..."
    "./others/appservice.sh $user"
    ;;
3)
    echo "Running raspap..."
    "./others/raspap.sh $user"
    ;;
4)
    echo "Running repository..."
    "./others/repository.sh $user"
    ;;
5)
    echo "Running staticip..."
    "./others/staticip.sh $user"
    ;;
6)
    echo "Running sudoers..."
    "./others/sudoers.sh $user"
    ;;
7)
    echo "Running virtualenv..."
    "./others/virtualenv.sh $user"
    ;;
0)
    echo "Exiting..."
    exit 0
    ;;
*)
    echo "Invalid option. Exiting..."
    exit 1
    ;;
esac

echo "Setup complete. Have fun with DemoJ!"

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
    echo "Invalid response"
    ;;
  esac
done