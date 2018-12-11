#!/usr/bin/env bash

[ $EUID -ne 0 ] && echo "run as root" >&2 && exit 1

set -e

pacman -Syy --noconfirm --needed \
	smartmontools \
	firefox chromium \
	sane \
	ntfs-3g exfat-utils mtools gparted \
	base-devel linux-headers go jdk8-openjdk \
	vim alacritty tmux screen \
	cups \
	keepassx2 \
	aria2 \
	aws-cli \
	net-tools tcpdump wireshark-cli \
	hugo \
	gimp \
	jq \
	alsa-utils pulseaudio pavucontrol \
	qemu qemu-arch-extra virt-viewer \
	docker docker-compose \
	electrum \
	libdvdcss dvdbackup cdrkit \
	vlc cmus mplayer sound-juicer \
	rclone \
	xfburn gst-plugins-good gst-plugins-base gst-plugins-bad gst-plugins-ugly \
	fbida ranger w3m \
	expect \
	ack

# Allow viewing images with framebuffer ala `fbi`
usermod -a -G video $USERNAME
# TODO May also need to run ranger --copy-config=scope which
# generates a script in $HOME/.config/ranger/ that you do not
# need to worry about, but helps with image previews.

usermod -a -G docker $USERNAME

systemctl enable docker
systemctl start docker

systemctl enable org.cups.cupsd.service
systemctl start org.cups.cupsd.service

sudo -u $USERNAME yaourt -S --needed --noconfirm \
	ttf-symbola

sudo -u $USERNAME go get github.com/github/git-lfs

# Best option for Dropbox on arm at this time
curl \
	-L \
	-o /usr/local/bin/dbxcli \
	"https://github.com/dropbox/dbxcli/releases/download/v2.1.2/dbxcli-linux-arm" && \
	chmod +x /usr/local/bin/dbxcli

