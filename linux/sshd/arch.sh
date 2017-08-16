#!/usr/bin/env bash

set -e

if [[ $EUID -ne 0 ]];
then
	echo "This script must be run as root" 1>&2
	exit 1
fi

if [ -z "${SSHUSER}" ];
then
	echo "Must specify SSHUSER" 1>&2
	exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pacman -S --noconfirm --needed \
	openssh

groupadd sshusers || true
usermod -a -G sshusers $SSHUSER || true
ufw allow 22

cp $DIR/sshd_config /etc/ssh/sshd_config
chmod 644 /etc/ssh/sshd_config
chown root:root /etc/ssh/sshd_config

systemctl enable sshd
systemctl start sshd
