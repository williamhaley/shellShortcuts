#!/usr/bin/env bash

[ $EUID -ne 0 ] && echo "run as root" >&2 && exit 1

if uname -a | grep -i 'x86_64' > /dev/null;
then
	source ./configure-x86_64.sh
fi
#source ./configure-raspberry-pi.sh

_noop()
{
	echo "not implemented"
}

_sudo()
{
	pacman -Syy --noconfirm --needed \
		sudo

	cat <<'EOF' > /etc/sudoers
root	ALL=(ALL) ALL
%sudo   ALL=(ALL) ALL

#includedir /etc/sudoers.d
EOF

	chmod 440 /etc/sudoers
	chown root:root /etc/sudoers
	groupadd sudo
}

_locale()
{
	cat <<'EOF' >/etc/locale.gen
en_US.UTF-8 UTF-8
EOF
	cat <<'EOF' >/etc/locale.conf
LANG=en_US.UTF-8
EOF

	locale-gen en_US.UTF-8

	ln -sf "/usr/share/zoneinfo/US/Central" /etc/localtime
}

_firewall()
{
	pacman -S --noconfirm --needed \
		ufw

	# ufw
	ufw --force disable
	ufw --force reset
	ufw --force default deny
	systemctl enable ufw
	systemctl start ufw
	ufw --force enable
}

_aur()
{
	# makepkg requires sudo
	pacman -Syy --noconfirm --needed \
		base-devel wget sudo git

	# Create a special user for running makepkg and install AUR depedencies without
	# root and without needing to know of or modify a "normal" user account.
	#
	# Running as root is forbidden.
	# https://wiki.archlinux.org/index.php/makepkg#Usage
	useradd -m aur-user

	cat <<'EOF' >/etc/sudoers.d/aur-user
aur-user ALL = (ALL) ALL
aur-user ALL = (root) NOPASSWD: /usr/bin/makepkg, /usr/bin/pacman
EOF

	# package-query
	su - aur-user -c "
		rm -rf /tmp/package-query
		mkdir -p /tmp/package-query
		cd /tmp/package-query
		wget https://aur.archlinux.org/cgit/aur.git/snapshot/package-query.tar.gz
		tar zxvf package-query.tar.gz
		cd package-query
		makepkg --syncdeps --rmdeps --install --noconfirm
	"

	# yay
	su - aur-user -c "
		rm -rf /tmp/yay
		mkdir -p /tmp/yay
		cd /tmp/yay
		wget https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz
		tar zxvf yay.tar.gz
		cd yay
		makepkg --syncdeps --rmdeps --install --noconfirm
	"
}

_sshd()
{
	pacman -S --noconfirm --needed \
		openssh

	groupadd sshusers || true
	ufw allow 22

	cat <<'EOF' >/etc/ssh/sshd_config
PermitRootLogin				 no

UsePAM						  yes
PrintMotd					   no

ClientAliveInterval			 0
ClientAliveCountMax			 0

AuthorizedKeysFile			  /home/%u/.ssh/authorized_keys

ChallengeResponseAuthentication no
PasswordAuthentication		  yes
PermitEmptyPasswords			no

UsePrivilegeSeparation		  sandbox
StrictModes					 yes

Subsystem					   sftp	internal-sftp

AllowGroups					 sshusers
EOF

	chmod 644 /etc/ssh/sshd_config
	chown root:root /etc/ssh/sshd_config

	systemctl enable sshd
	systemctl start sshd
}

_bluetooth()
{
	# https://wiki.archlinux.org/index.php/Bluetooth_headset#Headset_via_Bluez5.2Fbluez-alsa

	pacman -Syy --needed --noconfirm \
		pulseaudio pulseaudio-bluetooth pavucontrol bluez bluez-utils

	systemctl start bluetooth
	systemctl enable bluetooth
}

_apps()
{
	pacman -Syy --noconfirm --needed \
		sudo openssh \
		smartmontools \
		firefox chromium \
		sane \
		ntfs-3g exfat-utils mtools gparted \
		base-devel git linux-headers go jdk8-openjdk \
		alacritty tmux screen \
		keepassx2 \
		aria2 \
		rsync unzip \
		aws-cli \
		wget curl \
		net-tools tcpdump wireshark-cli \
		hugo \
		gimp \
		jq \
		handbrake handbrake-cli \
		vagrant intel-ucode memtest86+ rclone syslinux \
		alsa-utils pulseaudio pavucontrol \
		qemu qemu-arch-extra virt-viewer \
		libdvdcss dvdbackup cdrkit \
		vlc cmus mplayer sound-juicer \
		xfburn gst-plugins-good gst-plugins-base gst-plugins-bad gst-plugins-ugly \
		fbida ranger w3m \
		expect \
		ack \
		vim gedit

	if type _apps_platform | grep 'is a function' >/dev/null;
	then
		_apps_platform
	fi
}

commands=( _apps _audio _aur _bluetooth _firewall _init _kvm _locale _nvidia _sshd _sudo _video _virtualbox _wifi )
for command in "${commands[@]}"
do
	for arg in "$@"
	do
		if [ "_${arg}" = "${command}" ];
		then
			echo "executing: ${arg}"
			${command}
		fi
	done
done

# apps-pi
# apps-x86_64

# useradd -m -s /bin/bash -G sshusers,docker,sudo,vboxusers will || true
# usermod -a -G sshusers,docker,sudo,vboxusers || true
# passwd will
