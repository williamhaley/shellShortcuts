#!/usr/bin/env bash

[ $EUID -ne 0 ] && echo "run as root" >&2 && exit 1

# If you want a full X WM, just install Mate

pacman -Syy --noconfirm --needed \
	xorg xorg-server gnome-keyring openbox \
	noto-fonts noto-fonts-emoji ttf-dejavu

