#!/usr/bin/env bash

[ $EUID -ne 0 ] && echo "run as root" >&2 && exit 1

set -e

pacman -Syy --noconfirm --needed \
	firefox \
	sane \
	ntfs-3g exfat-utils syslinux mtools gparted \
	base-devel linux-headers go jdk8-openjdk \
	tmux screen \
	cups \
	keepassx2 \
	aria2 \
	aws-cli \
	net-tools tcpdump wireshark-cli \
	gimp \
	jq \
	pulseaudio pavucontrol \
	vagrant \
	virtualbox qemu qemu-arch-extra virt-viewer \
	intel-ucode \
	docker docker-compose \
	electrum \
	handbrake handbrake-cli dvdbackup cdrkit \
	vlc cmus mplayer sound-juicer \
	rclone \
	xfburn gst-plugins-good gst-plugins-base gst-plugins-bad gst-plugins-ugly \
	fbida ranger w3m \
	expect

# Allow viewing images with framebuffer ala `fbi`
usermod -a -G video $USERNAME
# TODO May also need to run ranger --copy-config=scope which
# generates a script in $HOME/.config/ranger/ that you do not
# need to worry about, but helps with image previews.

usermod -a -G docker $USERNAME
usermod -a -G vboxusers $USERNAME

systemctl enable docker
systemctl start docker

systemctl enable org.cups.cupsd.service
systemctl start org.cups.cupsd.service

sudo -u $USERNAME yaourt -S --needed --noconfirm \
	hfsprogs \
	google-chrome \
	visual-studio-code-bin \
	alacritty-git \
	ttf-symbola \
	dropbox

