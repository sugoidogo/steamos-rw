#!/bin/bash

if [ $1 = 'reset' ];then
    set -x
    systemctl stop var-lib-overlays-usr.mount
    mkfs.btrfs /home/.steamos/offload/usr.img -f
    systemctl start steamos-rw.target
    exit 0
fi

systemctl $1 steamos-rw.target --now