#!/usr/bin/env bash

if [[ $EUID -ne 0 ]];
then
	echo "This script must be run as root" 1>&2
	exit 1
fi

pacman -S --noconfirm --needed \
	firefox \
	sane \
	exfat-utils \
	base-devel linux-headers go jdk8-openjdk atom \
	cups \
	keepassx2 \
	transmission-gtk \
	aws-cli \
	net-tools \
	gimp \
	jq \
	vagrant \
	virtualbox \
	intel-ucode \
	docker \
	electrum \
	handbrake handbrake-cli dvdbackup cdrkit \
	ttf-symbola \
	vlc lollypop mplayer kid3 sound-juicer \
	rclone \
	xfburn gst-plugins-good gst-plugins-base gst-plugins-bad gst-plugins-ugly \
	redshift

usermod -a -G docker $USERNAME

systemctl enable docker
systemctl start docker

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

