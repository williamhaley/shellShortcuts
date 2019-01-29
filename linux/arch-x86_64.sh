#!/usr/bin/env bash

[ $EUID -ne 0 ] && echo "run as root" >&2 && exit 1

source ./arch-common.sh

video()
{
	pacman -Syy --noconfirm --needed \
		xorg xorg-server xorg-xinit \
		xterm lxterminal \
		numlockx \
		gnome-keyring \
		openbox obconf \
		tint2 \
		thunar tumbler \
		feh gpicview \
		xscreensaver xbindkeys xdotool \
		noto-fonts noto-fonts-emoji ttf-dejavu
}

nvidia()
{
	mkdir -p /etc/pacman.d/hooks

cat <<EOF > /etc/pacman.d/hooks/nvidia.hook
[Trigger]
Operation=Install
Operation=Upgrade
Operation=Remove
Type=Package
Target=nvidia

[Action]
Depends=mkinitcpio
When=PostTransaction
Exec=/usr/bin/mkinitcpio -p linux
EOF

	pacman -Sy --noconfirm --needed \
		nvidia nvidia-libgl
}

wifi()
{
	pacman -Syy --noconfirm --needed \
		wpa_supplicant linux-headers broadcom-wl-dkms
}

audio()
{
	pacman -Sy --noconfirm --needed \
		alsa-firmware alsa-plugins alsaplayer
}

apps-x86_64()
{
	pacman -Syy --noconfirm --needed \
		virtualbox \
		docker docker-compose \

	systemctl start docker
	systemctl enable docker

	groupadd vboxusers || true

	su - aur-user -c "
		yay -Syy --noconfirm --needed \
			google-chrome \
			visual-studio-code-bin \
			dropbox \
			git-lfs
	"
}

if [ -n "${1}" ];
then
	${1}
else
	locale
	sudo
	aur # depends on sudo
	firewall
	audio
	video
	nvidia
	wifi
	sshd # depends on firewall. Run after so we can add exception for port 22.
	apps
	apps-x86_64
	virtualbox
	bluetooth

	# useradd -m -s /bin/bash -G sshusers,docker,sudo,vboxusers will || true
	# usermod -a -G sshusers,docker,sudo,vboxusers || true
	# passwd will
fi

