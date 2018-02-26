#!/usr/bin/env bash

[ $EUID -ne 0 ] && echo "run as root" >&2 && exit 1

pacman -Syy --noconfirm --needed \
	xorg xorg-server \
	lightdm lightdm-gtk-greeter \
	networkmanager network-manager-applet gnome-keyring \
	noto-fonts noto-fonts-emoji ttf-dejavu

pacman -Syy --noconfirm \
	mate mate-extra

systemctl enable lightdm
systemctl enable NetworkManager
