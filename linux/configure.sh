#!/usr/bin/env bash

set -e

[ $EUID -ne 0 ] && echo "run as root" >&2 && exit 1

interrupt()
{
	echo "Script interrupted."
	exit 1
}

trap interrupt INT

_sudo()
{
	pacman -Syyu --noconfirm --needed sudo

	cat <<'EOF' > /etc/sudoers
root	ALL=(ALL) ALL
%sudo   ALL=(ALL) ALL

#includedir /etc/sudoers.d
EOF

	chmod 440 /etc/sudoers
	chown root:root /etc/sudoers
	groupadd sudo || true
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
	pacman -S --noconfirm --needed ufw

	# ufw
	ufw --force disable
	ufw --force reset
	ufw --force default deny
	systemctl enable ufw
	systemctl start ufw
	ufw --force enable
}

_touchpad()
{
	cat <<'EOF' >/etc/X11/xorg.conf.d/30-touchpad.conf
Section "InputClass"
    Identifier "devname"
    Driver "libinput"
    Option "Tapping" "on"
    Option "NaturalScrolling" "true"
EndSection
EOF
}

_acpi()
{
	pacman -Syyu --noconfirm --needed acpid

	cat <<'EOF' >/etc/acpi/handler.sh
#!/bin/bash
case "$1" in
    button/lid)
        case "$3" in
            close)
                echo -n "freeze" > /sys/power/state
                logger 'LID closed. Freezing system.'
                ;;
        esac
        ;;
esac
EOF

	chmod +x /etc/acpi/handler.sh

	systemctl start acpid
	systemctl enable acpid

	cat <<'EOF' >/etc/systemd/logind.conf
[Login]
HandlePowerKey=hibernate
HandleLidSwitch=ignore
EOF
}

_aur()
{
	# makepkg requires sudo
	pacman -Syyu --noconfirm --needed \
		base-devel wget sudo git

	# Create a special user for running makepkg and install AUR depedencies without
	# root and without needing to know of or modify a "normal" user account.
	#
	# Running as root is forbidden.
	# https://wiki.archlinux.org/index.php/makepkg#Usage
	useradd -m aur-user || true

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

	pacman -Syyu --needed --noconfirm \
		bluez bluez-utils

	systemctl start bluetooth
	systemctl enable bluetooth
}

_apps()
{
	pacman -Syyu --noconfirm --needed \
		sudo openssh \
		firefox chromium \
		ntfs-3g exfat-utils mtools syslinux \
		zsh vim gedit base-devel git linux-headers go docker docker-compose \
		keepassxc \
		wget curl rclone rsync unzip \
		net-tools tcpdump wireshark-cli nmap \
		transmission-cli \
		qemu qemu-arch-extra \
		handbrake handbrake-cli libdvdcss dvdbackup cdrkit \
		vlc cmus mplayer xfburn gst-plugins-good gst-plugins-base gst-plugins-bad gst-plugins-ugly \
		jq expect ack alacritty tmux screen \
		alsa-firmware alsa-plugins alsa-utils pulseaudio pavucontrol \
		memtest86+ \
		xorg xorg-server xf86-video-intel xorg-xinit xterm lxterminal numlockx gnome-keyring openbox obconf xcompmgr tint2 thunar thunar-archive-plugin file-roller tumbler ffmpegthumbnailer feh gpicview gthumb xscreensaver xbindkeys xdotool noto-fonts noto-fonts-emoji ttf-dejavu

	# Needed for Dropbox for the time being
	su - aur-user -c "
		cd /tmp
		curl -O https://linux.dropbox.com/fedora/rpm-public-key.asc
		gpg --import /tmp/rpm-public-key.asc
	"

	su - aur-user -c "
		yay -Syyu --noconfirm --needed \
			google-musicmanager \
			visual-studio-code-bin \
			dropbox \
			git-lfs
	"

	systemctl start docker
	systemctl enable docker

	# http://localhost:9091
	systemctl enable transmission
}

_wifi()
{
	# For hardware internal PCI WiFi cards that I buy
	pacman -Syyu --noconfirm --needed \
		broadcom-wl-dkms linux-headers

	# If using netctl you should disable dhcpcd service!
	pacman -Sy --noconfirm --needed \
		wpa_supplicant dialog netctl
}

_user()
{
	useradd -m -s /bin/bash $1 || true
	usermod -a -G sshusers $1 || true
	usermod -a -G sudo $1 || true
	usermod -a -G vboxusers $1 || true
	usermod -a -G docker $1 || true
	usermod -a -G transmission $1 || true
}

_nvidia()
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

	pacman -Syyu --noconfirm --needed nvidia nvidia-libgl
}

_sudo
_locale
_firewall
_aur
_apps
_user "${1}"
_wifi

# commands are ordered so that vital systems run first
# aur is often needed by others, so run that first. Same for
# video being before nvidia, etc.
commands=( _sudo _locale _init _aur _apps _audio _bluetooth _firewall _kvm _video _nvidia _sshd _wifi )
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

