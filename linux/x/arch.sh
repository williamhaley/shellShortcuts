#!/usr/bin/env bash

[ $EUID -ne 0 ] && echo "run as root" >&2 && exit 1

# If you want a full X WM, just install Mate

pacman -Syy --noconfirm --needed \
	xorg xorg-server xorg-xinit \
	xterm lxterminal \
	gnome-keyring \
	openbox \
	thunar \
	noto-fonts noto-fonts-emoji ttf-dejavu

