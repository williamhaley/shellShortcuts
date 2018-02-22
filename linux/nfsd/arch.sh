#!/usr/bin/env bash

[ $EUID -ne 0 ] && echo "run as root" >&2 && exit 1

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cp "$DIR/nfs-common.conf" /etc/conf.d/nfs-common.conf
cp "$DIR/nfs-server.conf" /etc/conf.d/nfs-server.conf
cp "$DIR/exports" /etc/exports

pacman -Sy

pacman -S --noconfirm --needed \
	nfs-utils

ufw allow nfs

systemctl enable nfs-server
systemctl start nfs-server

# Reload configs.
exportfs -arv

echo "Create exports."
