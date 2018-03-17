#!/usr/bin/env bash

[ $EUID -ne 0 ] && echo "run as root" >&2 && exit 1

# If you want a full X WM, just install Mate

# Sample .xinitrc
#   lxpanel &
#   xscreensaver &
#   exec openbox-session

pacman -Syy --noconfirm --needed \
	xorg xorg-server xorg-xinit \
	xterm lxterminal \
	gnome-keyring \
	openbox obconf \
	lxpanel thunar \
	xscreensaver \
	noto-fonts noto-fonts-emoji ttf-dejavu

