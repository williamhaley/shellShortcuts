#!/usr/bin/env bash

# This can be done without pulse, but it's a huge pain. Errors
# getting thrown, FF and other browsers won't use alsa with
# bt properly
# https://wiki.archlinux.org/index.php/Bluetooth_headset#Headset_via_Bluez5.2Fbluez-alsa
#
# Pulse is 100x easier.

sudo pacman -Syy --needed --noconfirm \
	pulseaudio pulseaudio-bluetooth pavucontrol \
	bluez bluez-utils

systemctl start bluetooth
systemctl enable bluetooth

