#!/bin/bash
# installs the steamos-rw service and pacman configuration to allow installing system packages

if [ `id -u` != 0 ];then
    read -rp "This script must be run as root"
    exit 1
fi

set -xeuo pipefail

cp *.target *.service *.mount /etc/systemd/system/
cp *.service /etc/systemd/user/
systemctl daemon-reload

truncate /home/.steamos/offload/usr.img -s $(blockdev --getsize64 $(findmnt -n -o SOURCE --target /home))
mkfs.btrfs /home/.steamos/offload/usr.img || true
mkdir -p /var/lib/overlays/usr
systemctl start var-lib-overlays-usr.mount
mkdir -p /var/lib/overlays/usr/work /var/lib/overlays/usr/upper
systemctl enable steamos-rw.target --now
ln -s /bin/steamos-rw /opt/steamos-rw/steamos-rw.sh

cat <<EOF >> /etc/pacman.conf
# block updates for steamos pre-installed packages
# to keep things from breaking
[options]
IgnorePkg = $(pacman -Qqe | tr '\n' ' ')
EOF
cat <<EOF >> /etc/pacman.d/mirrorlist
# steamos repos have borked signing, rely on https for security
SigLevel = Optional TrustAll
EOF
pacman-key --init
pacman -Syu pacman-contrib --noconfirm
systemctl enable paccache.timer

set +x
read -rp "Install complete, you may close this window or press enter to exit"