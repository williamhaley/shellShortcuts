#!/usr/bin/env bash

if [[ $EUID -ne 0 ]];
then
	echo "This script must be run as root" 1>&2
	exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pacman -S --noconfirm --needed \
	ufw

# ufw
ufw --force disable
ufw --force reset
ufw --force default deny
systemctl enable ufw
systemctl start ufw
ufw --force enable
