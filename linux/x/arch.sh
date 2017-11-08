#!/usr/bin/env bash

if [[ $EUID -ne 0 ]];
then
	echo "This script must be run as root" 1>&2
	exit 1
fi

pacman -S --noconfirm --needed \
	xorg xorg-server \
	lightdm lightdm-gtk-greeter \
	networkmanager network-manager-applet \
	noto-fonts ttf-dejavu

pacman -S --noconfirm \
	mate mate-extra

systemctl enable lightdm
systemctl enable NetworkManager
