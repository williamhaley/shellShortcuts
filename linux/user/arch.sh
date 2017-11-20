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
	keepassx2 \
	aws-cli \
	net-tools \
	gimp \
	vagrant \
	virtualbox \
	docker \
	handbrake handbrake-cli dvdbackup cdrkit \
	ttf-symbola \
	vlc lollypop mplayer kid3 sound-juicer \
	rclone \
	xfburn gst-plugins-good gst-plugins-base gst-plugins-bad gst-plugins-ugly

usermod -a -G docker $USERNAME

systemctl enable docker
systemctl start docker

sudo -u $USERNAME yaourt -S --needed --noconfirm \
	hfsprogs \
	google-chrome \
	vokoscreen
