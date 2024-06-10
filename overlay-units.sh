#!/bin/bash
set -x

ACTION=$1

if [ `id -u` = 0 ];then
    MODE=system
else
    MODE=user
fi

SEARCH_PATHS=$(find /var/lib/overlays/usr/upper -wholename "*/systemd/$MODE")

for path in $SEARCH_PATHS;do
    for unit in $(find $path -maxdepth 1 -type f);do
        UNITS+="$(basename $unit) "
    done
done

for unit in $UNITS; do
    if [ $ACTION = 'start' ];then
        if systemctl --$MODE is-enabled $unit;then
            systemctl --$MODE $ACTION $unit
        fi
    else
        systemctl --$MODE $ACTION $unit
    fi
done

if [ `id -u` = 0 ];then systemctl --user -M deck@ $ACTION overlay-units.service;fi