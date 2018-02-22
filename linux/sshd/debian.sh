#!/usr/bin/env bash

[ $EUID -ne 0 ] && echo "run as root" >&2 && exit 1

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

apt-get install openssh-server 

groupadd sshusers || true
usermod -a -G sshusers $SSHUSER || true
ufw allow 22

cp $DIR/sshd_config /etc/ssh/sshd_config
chmod 644 /etc/ssh/sshd_config
chown root:root /etc/ssh/sshd_config

systemctl enable ssh
systemctl start ssh
