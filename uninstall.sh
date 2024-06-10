#!/bin/bash

if [ `id -u` != 0 ];then
    read -rp "This script must be run as root"
    exit 1
fi

echo "This will remove steamos-rw and reboot your device"
read -rp "Press Enter to continue: "
set -x
systemctl stop var-lib-overlays-usr.mount
cd /etc/systemd/system
rm usr.mount steamos-rw.target overlay-units.service var-lib-overlays-usr.mount
cd /etc/system/user
rm overlay-units.service
reboot