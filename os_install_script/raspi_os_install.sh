#!/bin/bash

#TEST_SCRIPT

if [ $EUID -ne 0 ]; then
	echo "error: you cannot perform this operation unless you are root." >&2
	exit 1
fi

clear

read -e -p "Enter image path: " OS_PATH
REAL_OS_PATH=`readlink -e $OS_PATH`

DISK_LIST=`lsblk | grep "disk" | awk '{print $1 "\t" $4}'`
IFS=$'\n'
PS3="Chose your disk: "
select DISK_INFO in $DISK_LIST;
do
	DISK=`echo "$DISK_INFO" | awk '{print $1}'`
	break
done

read -p "Content of disk $DISK will be deleted, are you sure ? [Y/n] " CONFIRM
if [ "$CONFIRM" == "Y" ] || [ "$CONFIRM" == "y" ]; then
	echo "THIS OPERATION MAY TAKE A WHILE..."
	sudo dd bs=1M if=$REAL_OS_PATH of=/dev/$DISK conv=fsync > /dev/null 2>&1
	#sudo mount /dev/"$DISK"p2 /mnt
	#sudo touch /mnt/etc/systemd/system/getty@tty1.service.d/autologin.conf
	#sudo echo -e "[Service]\nExecStart=\nExecStart=-/sbin/agetty --autologin pi --noclear %I \$TERM" > /mnt/etc/systemd/system/getty@tty1.service.d/autologin.conf
	#sudo umount /mnt
else
	echo "Abort" >&2
fi
exit 0

#Check params (add sentinel code)
#Check command errors
