#!/usr/bin/env bash

[ $EUID -ne 0 ] && echo "run as root" >&2 && exit 1

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pacman -Syy --noconfirm --needed \
	base-devel wget rsync vim tmux git curl unzip \
	sudo openssh wpa_supplicant \
	memtest86+

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

# yaourt pre-reqs
pacman -Syy --noconfirm --needed base-devel wget
mkdir -p /tmp/aur
chown $USERNAME /tmp/aur

# package-query
cd /tmp/aur
sudo -u $USERNAME wget https://aur.archlinux.org/cgit/aur.git/snapshot/package-query.tar.gz
sudo -u $USERNAME tar zxvf package-query.tar.gz
cd package-query
sudo -u $USERNAME makepkg -si --noconfirm

# yaourt
cd /tmp/aur
sudo -u $USERNAME wget https://aur.archlinux.org/cgit/aur.git/snapshot/yaourt.tar.gz
sudo -u $USERNAME tar zxvf yaourt.tar.gz
cd yaourt
sudo -u $USERNAME makepkg -si --noconfirm
