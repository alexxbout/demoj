#!/usr/bin/sudo bash

echo -e "\033[1;32m
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.....
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@...@
@@@@@@@@@@@@@@@@@@@@@@@@@@@//////@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@*******@@///@@@@@////(//@@@***************************,,,,,,,,,,.......@
@@@@*****@@@@@@@@///@@@@///(@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@...@
@@***@@@@///////@///@@@@@#//////@@@@@@@@//////@@@//////@@@@@@@@///////@@@@@@...@
@***@@@////@@@@/////@@@////@@@@////@@@///#@@@/////@@@@///@@@@///@@@@@////@@@...@
@**@@@///@@@@@@@@///@@///@@/////////@@//@@@@@@///@@@@@@///@@//@@@@@@@@@///@@...@
***@@@///@@@@@@@@///@@//////@@@@@@@/@@//@@@@@@///@@@@@@///@@//@@@@@@@@@///@@...@
@***@@@///@@@@@////@@@@///@@@@@////@@@//@@@@@@///@@@@@@///@@@///@@@@@////@@@..&@
@@***@@@@///////@@@@@@@@@///////&@@@@@//@@@@@@///@@@@@@///@@@@@///////@@@@...@@@
@@@@****&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,...&@@@@
@@@@@@@/******************************************************,,,,,,,,,,@@@@@@@@
\033[0m"

echo "Welcome to our setup script!" 

#UPDATE THIS LIST
echo "
This script will : 
  - udpdate and upgrade your system 
  - install pip
  - install smbus
  - install rpi_ws281x
  - enable i2C bus
  - setup python path
"

echo "Please check if you are running this script in the git repo root directory before proceeding."

while true; do

read -p "Do you want to proceed? (y/n) " yn

case $yn in 
	[yY] ) echo ok, we will proceed;
		break;;
	[nN] ) echo exiting...;
		exit;;
	* ) echo invalid response;;
esac

done

echo "Starting setup"

echo "System update"
sudo apt-get update -y
echo "System upgrade"

while true; do

read -p "Do you want to upgrade the system? (y/n) " yn

case $yn in 
	[yY] ) sudo apt-get upgrade -y;
		break;;
	[nN] ) echo installation skipped...;
		break;;
	* ) echo invalid response;;
esac

done

#ADD THINGS TO INSTALL/SETUP HERE
echo "Install python3-pip"
sudo apt-get install python3-pip -y
echo "Install build-essential"
sudo apt-get install build-essential -y
echo "Install smbus"
sudo pip3 install smbus --break-system-packages
echo "Install strip led API"
sudo pip3 install rpi_ws281x --break-system-packages
echo "Setup I2C"
#enabling I2C
if [ $(sudo raspi-config nonint get_i2c) -eq 0 ]
then
echo "I2C already enabled"
else
sudo raspi-config nonint do_i2c 0
echo "I2C enabled!"
fi
#setup python path variable for libs
echo "Setup the python path variable"

export PYTHONPATH=$PWD"/lib"
grep -vwE "export PYTHONPATH=" ~/.bashrc > tmpsetup
mv tmpsetup ~/.bashrc
echo "export PYTHONPATH="$PYTHONPATH >> ~/.bashrc

#sudo grep -vwE "export PYTHONPATH=" /root/.bashrc > tmpsetup
#sudo mv tmpsetup /root/.bashrc
#sudo echo "export PYTHONPATH="$PYTHONPATH >> /root/.bashrc

echo "PTHONPATH variable set to "$PYTHONPATH
echo "DONE"
