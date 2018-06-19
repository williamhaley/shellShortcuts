#!/usr/bin/env bash

set -e

[ $EUID -ne 0 ] && echo "run as root" >&2 && exit 1

# If you want a full X WM, just install Mate

pacman -Syy --noconfirm --needed \
	xorg xorg-server xorg-xinit \
	xterm lxterminal \
	numlockx \
	gnome-keyring \
	openbox obconf \
	tint2 \
	thunar tumbler \
	feh gpicview \
	xscreensaver xbindkeys xdotool \
	noto-fonts noto-fonts-emoji ttf-dejavu
