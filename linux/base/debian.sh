#!/usr/bin/env bash

[ $EUID -ne 0 ] && echo "run as root" >&2 && exit 1

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

apt-get install --no-install-recommends --yes \
	build-essential wget rsync vim tmux git curl unzip \
	sudo ssh wpasupplicant

# sudo
usermod -a -G sudo $USERNAME || true
cp $DIR/sudoers /etc/sudoers
chmod 440 /etc/sudoers
chown root:root /etc/sudoers

# locale
cp $DIR/locale.gen /etc/locale.gen
cp $DIR/locale.conf /etc/default/locale
locale-gen en_US.UTF-8
locale-gen

# keyboard
cp $DIR/keyboard /etc/default/keyboard

# timezone
cp /usr/share/zoneinfo/America/Chicago /etc/localtime

# ssh
mkdir -p /home/$USERNAME/.ssh
chown $USERNAME:$USERNAME /home/$USERNAME/.ssh
chmod 700 /home/$USERNAME/.ssh
touch /home/$USERNAME/.ssh/authorized_keys
chown $USERNAME:$USERNAME /home/$USERNAME/.ssh/authorized_keys
chmod 600 /home/$USERNAME/.ssh/authorized_keys

