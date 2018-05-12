#!/usr/bin/env bash

[ $EUID -ne 0 ] && echo "run as root" >&2 && exit 1

apt-get install --no-install-recommends --yes \
	iceweasel \
	sane \
	ntfs-3g exfat-utils syslinux-common mtools gparted \
	build-essential golang default-jdk \
	hfsprogs \
	tmux screen \
	cups \
	keepassx \
	aria2 \
	python python-pip libssl-dev \
	net-tools tcpdump \
	gimp \
	jq \
	pulseaudio pavucontrol \
	vagrant \
	qemu \
	docker docker-compose \
	electrum \
	dvdbackup \
	fonts-symbola \
	vlc cmus mplayer sound-juicer \
	rclone \
	youtube-dl \
	ffmpeg \
	xfburn \
	ranger w3m

pip install awscli

# Allow viewing images with framebuffer ala `fbi`
usermod -a -G video $USERNAME
# TODO May also need to run ranger --copy-config=scope which
# generates a script in $HOME/.config/ranger/ that you do not
# need to worry about, but helps with image previews.

usermod -a -G docker $USERNAME
