#!/usr/bin/env bash

set -e

[ $EUID -ne 0 ] && echo "run as root" >&2 && exit 1

# If you want a full X WM, just install Mate

apt-get install --no-install-recommends --yes \
	xorg xserver-xorg xinit \
	xterm lxterminal \
	numlockx \
	gnome-keyring \
	openbox obconf \
	tint2 \
	thunar tumbler \
	feh \
	xscreensaver xbindkeys xdotool \
	fonts-noto ttf-dejavu
