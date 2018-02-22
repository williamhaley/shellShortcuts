#!/usr/bin/env bash

[ $EUID -ne 0 ] && echo "run as root" >&2 && exit 1

pacman -S --noconfirm --needed \
	xorg xorg-server \
	lightdm lightdm-gtk-greeter \
	networkmanager network-manager-applet gnome-keyring \
	noto-fonts ttf-dejavu

pacman -S --noconfirm \
	mate mate-extra

systemctl enable lightdm
systemctl enable NetworkManager
