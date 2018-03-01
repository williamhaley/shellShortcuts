#!/usr/bin/env bash

[ $EUID -ne 0 ] && echo "run as root" >&2 && exit 1

pacman -Syy --noconfirm --needed \
	xorg xorg-server \
	lightdm lightdm-gtk-greeter gnome-keyring \
	noto-fonts noto-fonts-emoji ttf-dejavu

pacman -Syy --noconfirm \
	mate mate-extra

pacman -Syy --noconfirm \
	wicd wicd-gtk

# wicd auto-start behavior is weird. Only launch
# if manually if needed. Use a script/cli for wpa_supplicant
# otherwise.
rm /etc/xdg/autostart/wicd-tray.desktop

systemctl enable lightdm

