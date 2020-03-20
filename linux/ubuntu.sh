#!/usr/bin/env bash

# Ubuntu Server configuration script

set -e

[ $EUID -ne 0 ] && echo "run as root" >&2 && exit 1

user=will

useradd -m -s /bin/bash $user || true

apt update && apt install --no-install-recommends -y \
    xinit xserver-xorg firefox lightdm openbox ufw \
    nginx vlc

apt install pulseaudio -y

(
	cd /tmp
	curl -O https://dl.eff.org/certbot-auto
	mv certbot-auto /usr/local/bin/certbot-auto
	chown root /usr/local/bin/certbot-auto
	chmod 0755 /usr/local/bin/certbot-auto
)

cat <<EOF >/home/$user/.xinitrc
#!/bin/sh

exec openbox-session
EOF

chown $user:$user /home/$user/.xinitrc

(
	cd /tmp
	# Get the package from https://www.nomachine.com/download/linux&id=1
	curl -L "https://download.nomachine.com/download/6.9/Linux/nomachine_6.9.2_1_amd64.deb" -o nomachine.deb
	dpkg -i nomachine.deb
	systemctl enable nxserver
	systemctl start nxserver
)

