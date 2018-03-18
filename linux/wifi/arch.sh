#!/usr/bin/env bash

[ $EUID -ne 0 ] && echo "run as root" >&2 && exit 1

pacman -Syy --noconfirm --needed \
	broadcom-wl-dkms linux-headers

