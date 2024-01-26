#!/bin/bash

#TOD SECURITY ISSUE: do not lauch all command on root priv
if [ $EUID -ne 0 ]; then
	echo "error: you cannot perform this operation unless you are root." >&2
	exit 1
fi

clear

cat << EOF
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

EOF

HOME=`su -c "env | grep HOME | cut -d \"=\" -f 2" $(logname)`

PS3="Chose the raspberry: "
select RASPBERRY in deneb vega altair;
do
  #TODO check user input
  HOSTNAME=$RASPBERRY
  break
done
echo "$HOSTNAME selected"

read -e -p "Enter image path: " OS_PATH
#TODO check if file exist and is a img file
REAL_OS_PATH=`readlink -e $OS_PATH`
#TODO repair list use lsblk -l
#TODO DO NOT PRINT SYSTEM DISK
DISK_LIST=`lsblk | grep "disk" | awk '{print $1 "\t" $4}'`
IFS=$'\n'
PS3="Chose your disk: "
select DISK_INFO in $DISK_LIST;
do
  #TODO check user input
	DISK=`echo "$DISK_INFO" | awk '{print $1}'`
	break
done

read -p "Content of disk $DISK will be deleted, are you sure ? [Y/n] " CONFIRM
if [ "$CONFIRM" == "Y" ] || [ "$CONFIRM" == "y" ]; then
	#TODO progress bar ??
  echo "THIS OPERATION MAY TAKE A WHILE..."
	sudo dd bs=1M if=$REAL_OS_PATH of=/dev/$DISK conv=fsync
	
  PARTITION=`lsblk -l | grep "$DISK.1" | awk '{print $1}'`
  sudo mount /dev/"$PARTITION" /mnt 
  
  DIR_NAME=".rasp_co"
  KEY_DIR="$HOME/$DIR_NAME" #TODO $HOME on logname
  KEY_NAME="key_$HOSTNAME"
  echo "Generating keys into $KEY_DIR"
  if [ ! -d "$KEY_DIR" ];
  then
    su -c "mkdir $KEY_DIR" $(logname)
  else
    if [ -f "$KEY_DIR/$KEY_NAME" ];
    then
      su -c "rm -rf \"$KEY_DIR/$KEY_NAME\"" $(logname)
      su -c "rm -rf \"$KEY_DIR/$KEY_NAME.pub\"" $(logname) #TODO test regex
    fi
  fi
  su -c "ssh-keygen -q -f \"$KEY_DIR/$KEY_NAME\" -N \"\"" $(logname)
  PUB_KEY=`cat $KEY_DIR/$KEY_NAME.pub | awk '{print $1 " " $2}'`
  echo "Finished !"

  echo "Connection configuration"
  read -p "Enter SSID: " SSID
  read -s -p "Password: " PSK #TODO SECURITY ISSUES: hide psk
  PSK=`echo -n $PSK | iconv -t utf16le | openssl dgst -md4 -provider legacy` | awk '{print $2}' #TODO check if binaries exist

  echo "\nGenerating firstrun script..."
  
  sudo touch /mnt/firstrun.sh
  sudo cat > /mnt/firstrun.sh << EOF
#!/bin/bash

set +e

CURRENT_HOSTNAME=\`cat /etc/hostname | tr -d " \\t\\n\\r"\`
if [ -f /usr/lib/raspberrypi-sys-mods/imager_custom ]; then
   /usr/lib/raspberrypi-sys-mods/imager_custom set_hostname $HOSTNAME
else
   echo $HOSTNAME >/etc/hostname
   sed -i "s/127.0.1.1.*\$CURRENT_HOSTNAME/127.0.1.1\\t$HOSTNAME/g" /etc/hosts
fi
FIRSTUSER=\`getent passwd 1000 | cut -d: -f1\`
FIRSTUSERHOME=\`getent passwd 1000 | cut -d: -f6\`
if [ -f /usr/lib/raspberrypi-sys-mods/imager_custom ]; then
   /usr/lib/raspberrypi-sys-mods/imager_custom enable_ssh -k '$PUB_KEY'
else
   install -o "\$FIRSTUSER" -m 700 -d "\$FIRSTUSERHOME/.ssh"
   install -o "\$FIRSTUSER" -m 600 <(printf "$PUB_KEY") "\$FIRSTUSERHOME/.ssh/authorized_keys"
   echo 'PasswordAuthentication no' >>/etc/ssh/sshd_config
   systemctl enable ssh
fi
if [ -f /usr/lib/raspberrypi-sys-mods/imager_custom ]; then
   /usr/lib/raspberrypi-sys-mods/imager_custom set_wlan '$SSID' '$PSK' 'FR'
else
cat >/etc/wpa_supplicant/wpa_supplicant.conf <<'WPAEOF'
country=FR
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
ap_scan=1

update_config=1
network={
	ssid="$SSID"
	password=hash:$PSK
}

WPAEOF
   chmod 600 /etc/wpa_supplicant/wpa_supplicant.conf
   rfkill unblock wifi
   for filename in /var/lib/systemd/rfkill/*:wlan ; do
       echo 0 > \$filename
   done
fi
rm -f /boot/firstrun.sh
sed -i 's| systemd.run.*||g' /boot/cmdline.txt
exit 0

EOF

  CMDLINE=`sudo cat /mnt/cmdline.txt`
  sudo echo "$CMDLINE systemd.run=/boot/firstrun.sh systemd.run_success_action=reboot systemd.unit=kernel-command-line.target" > /mnt/cmdline.txt

  echo "Finished !"
  echo "use: ssh -i $KEY_DIR/$KEY_NAME pi@$HOSTNAME.local to connect"
  sudo umount /mnt
else
	echo "Abort" >&2
fi
exit 0
