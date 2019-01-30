_init()
{
	_noop
}

_video()
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

	pacman -Sy --noconfirm --needed \
		nvidia nvidia-libgl
}

_wifi()
{
	pacman -Syy --noconfirm --needed \
		wpa_supplicant linux-headers broadcom-wl-dkms
}

_audio()
{
	pacman -Sy --noconfirm --needed \
		alsa-firmware alsa-plugins alsaplayer
}

_apps_platform()
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

_kvm()
{
	set -e

	LC_ALL=C lscpu | grep -E 'VT-x|AMD-V' > /dev/null || {
		echo "virtualization not supported"
		return
	}

	grep for whatever... uh, devices?

	# https://medium.com/@calerogers/gpu-virtualization-with-kvm-qemu-63ca98a6a172
	# https://davidyat.es/2016/09/08/gpu-passthrough/
	# https://heiko-sieger.info/running-windows-10-on-linux-using-kvm-with-vga-passthrough/
	# https://en.wikipedia.org/wiki/Kernel-based_Virtual_Machine
	# https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF

	# I should get a second PCI card, isolate its group/PCI info, then see the kernel module and other stuff loading.

	# First one should be obvious. Second one is to make sure non-compatible hardware isn't made available
	# Get amd_iommu=on iommu=pt in /etc/default/grub and re-generate

	set +e
}
