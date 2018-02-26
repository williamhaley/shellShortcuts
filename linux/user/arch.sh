#!/usr/bin/env bash

[ $EUID -ne 0 ] && echo "run as root" >&2 && exit 1

pacman -Syy --noconfirm --needed \
	firefox \
	sane \
	exfat-utils \
	base-devel linux-headers go jdk8-openjdk \
	cups \
	keepassx2 \
	transmission-gtk \
	aws-cli \
	net-tools bluez bluez-utils blueman \
	gimp \
	jq \
	vagrant \
	virtualbox qemu \
	intel-ucode \
	docker \
	electrum \
	handbrake handbrake-cli dvdbackup cdrkit \
	ttf-symbola \
	pavucontrol vlc cmus mplayer kid3 sound-juicer \
	gparted \
	rclone \
	xfburn gst-plugins-good gst-plugins-base gst-plugins-bad gst-plugins-ugly \
	redshift \
	fbida ranger w3m \
	trash-cli

# Allow viewing images with framebuffer ala `fbi`
usermod -a -G video $USERNAME
# TODO May also need to run ranger --copy-config=scope which
# generates a script in $HOME/.config/ranger/ that you do not
# need to worry about, but helps with image previews.

usermod -a -G docker $USERNAME

systemctl enable docker
systemctl start docker

systemctl start bluetooth
systemctl enable bluetooth

systemctl enable org.cups.cupsd.service
systemctl start org.cups.cupsd.service

sudo -u $USERNAME \
	XDG_RUNTIME_DIR="/run/user/$(id -u $USERNAME)" \
	DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus" \
	systemctl --user enable redshift
sudo -u $USERNAME \
	XDG_RUNTIME_DIR="/run/user/$(id -u $USERNAME)" \
	DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus" \
	systemctl --user start redshift

sudo -u $USERNAME yaourt -S --needed --noconfirm \
	hfsprogs \
	google-chrome \
	vokoscreen \
	visual-studio-code-bin \
	slack-desktop

