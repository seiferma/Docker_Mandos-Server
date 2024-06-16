#!/bin/bash

ACTION=$1

if [[ "$ACTION" == "default" ]]; then
    mkdir -p /run/dbus
    dbus-daemon --fork --system --print-address
    exec /usr/sbin/mandos --debug --no-zeroconf --no-dbus -p 8080 --configdir /etc/mandos --statedir /var/lib/mandos
else
    exec "$@"
fi
