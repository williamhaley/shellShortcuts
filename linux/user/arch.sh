#!/usr/bin/env bash

if [[ $EUID -ne 0 ]];
then
	echo "This script must be run as root" 1>&2
	exit 1
fi

pacman -S --noconfirm --needed \
	atom \
	sane \
	exfat-utils \
	base-devel \
	keepassx2 \
	go jdk8-openjdk \
	aws-cli python-pip \
	net-tools \
	gimp \
	redshift python-gobject python-xdg \
	vagrant \
	virtualbox virtualbox-guest-utils virtualbox-guest-modules-arch \
	docker \
	linux-headers \
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

# Fix issue with Dropbox.
echo "fs.inotify.max_user_watches = 100000" > /etc/sysctl.d/99-sysctl.conf
sysctl --system
