#!/usr/bin/sudo bash

echo "
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
"

echo "Welcome to our setup script!" 

#UPDATE THIS LIST
echo "
This script will : 
  - udpdate and upgrade your system 
  - install pip
  - install smbus
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
#ADD THINGS TO INSTALL/SETUP HERE
echo "System update"
sudo apt-get update -y
echo "System upgrade"
sudo apt-get upgrade -y
echo "Install python3-pip"
sudo apt-get install python3-pip -y
echo "Install build-essential"
sudo apt-get install build-essential -y
echo "Install smbus"
sudo pip install smbus --break-system-packages
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

echo "export PYTHONPATH="$PWD"/lib" >> ~/.bashrc

echo "DONE"
