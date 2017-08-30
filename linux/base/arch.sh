#!/usr/bin/env bash

set -e

if [[ $EUID -ne 0 ]];
then
	echo "This script must be run as root" 1>&2
	exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pacman -S --noconfirm --needed \
	base-devel wget rsync vim tmux git curl unzip sudo openssh

# sudo
usermod -a -G sudo $USERNAME || true
cp $DIR/sudoers /etc/sudoers
chmod 440 /etc/sudoers
chown root:root /etc/sudoers

# locale
cp $DIR/locale.gen /etc/locale.gen
cp $DIR/locale.conf /etc/locale.conf
locale-gen en_US.UTF-8
locale-gen

# ssh
mkdir -p /home/$USERNAME/.ssh
chown $USERNAME:$USERNAME /home/$USERNAME/.ssh
chmod 700 /home/$USERNAME/.ssh
touch /home/$USERNAME/.ssh/authorized_keys
chown $USERNAME:$USERNAME /home/$USERNAME/.ssh/authorized_keys
chmod 600 /home/$USERNAME/.ssh/authorized_keys