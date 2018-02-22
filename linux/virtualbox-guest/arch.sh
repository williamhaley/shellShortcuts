#!/usr/bin/env bash

[ $EUID -ne 0 ] && echo "run as root" >&2 && exit 1

pacman -S --noconfirm --needed \
	virtualbox-guest-utils virtualbox-guest-modules-arch
