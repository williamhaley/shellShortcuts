#!/usr/bin/env bash

[ $EUID -ne 0 ] && echo "run as root" >&2 && exit 1

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
