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
		thunar tumbler ffmpegthumbnailer \
		feh gpicview \
		xscreensaver xbindkeys xdotool \
		noto-fonts noto-fonts-emoji ttf-dejavu

	yay -Syy --noconfirm \
		thunar-thumbnailers
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

	usermod -a -G docker will
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
	# https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF#Setting_up_IOMMU
	# https://medium.com/@calerogers/gpu-virtualization-with-kvm-qemu-63ca98a6a172
	# https://davidyat.es/2016/09/08/gpu-passthrough/
	# https://heiko-sieger.info/running-windows-10-on-linux-using-kvm-with-vga-passthrough/
	# https://en.wikipedia.org/wiki/Kernel-based_Virtual_Machine
	# https://taxes.moe/2017/07/08/linux-and-windows-running-simultaneously-with-gpu-passthrough/
	# https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF#Setting_up_the_guest_OS

	pacman -Syy --noconfirm --needed \
		qemu libvirt ovmf virt-manager \
		ebtables dnsmasq

	LC_ALL=C lscpu | grep -E 'VT-x|AMD-V' > /dev/null || {
		echo "virtualization not supported"
		return
	}

	zgrep CONFIG_KVM /proc/config.gz | grep -E 'KVM=m|KVM=y' > /dev/null || {
		echo "KVM module not available in kernel"
		return
	}

	zgrep CONFIG_KVM /proc/config.gz | grep -E 'KVM_INTEL=m|KVM_INTEL=y|KVM_AMD=m|KVM_AMD=y' > /dev/null || {
		echo "KVM_AMD or KVM_INTEL module not available in kernel"
		return
	}

	zgrep VIRTIO /proc/config.gz > /dev/null || {
		echo "VIRTIO modules not available in kernel"
		return
	}

	# AMD
	cat /proc/cpuinfo | grep -i AuthenticAMD > /dev/null && {
		cat /etc/default/grub | grep -i GRUB_CMDLINE_LINUX_DEFAULT | grep -i amd_iommu=on > /dev/null || {
			echo "Add AMD IOMMU support to Grub config"
			sed -i -E 's|GRUB_CMDLINE_LINUX_DEFAULT=\"(.*)\"|GRUB_CMDLINE_LINUX_DEFAULT=\"\1 amd_iommu=on\"|g' /etc/default/grub
		}
	}

	# Intel
	cat /proc/cpuinfo | grep -i intel > /dev/null && {
		cat /etc/default/grub | grep -i GRUB_CMDLINE_LINUX_DEFAULT | grep -i amd_iommu=on > /dev/null || {
			echo "Add Intel IOMMU support to Grub config"
			sed -i -E 's|GRUB_CMDLINE_LINUX_DEFAULT=\"(.*)\"|GRUB_CMDLINE_LINUX_DEFAULT=\"\1 intel_iommu=on\"|g' /etc/default/grub
		}
	}

	cat /etc/default/grub | grep -i GRUB_CMDLINE_LINUX_DEFAULT | grep -i iommu=pt > /dev/null || {
		echo "Set IOMMU selective passthrough support in Grub config"
		sed -i -E 's|GRUB_CMDLINE_LINUX_DEFAULT=\"(.*)\"|GRUB_CMDLINE_LINUX_DEFAULT=\"\1 iommu=pt\"|g' /etc/default/grub
	}

	cat /etc/mkinitcpio.conf | grep -i MODULES= | grep -i "vfio_pci vfio vfio_iommu_type1 vfio_virqfd" > /dev/null || {
		echo "Add entry to mkinitcpio MODULES config"
		# If ever adding/using graphics modules here. i915, noveau, etc., add them at the *end* of the MODULES
		sed -i -E 's|MODULES=\((.*)\)|MODULES=\(vfio_pci vfio vfio_iommu_type1 vfio_virqfd \1\)|g' /etc/mkinitcpio.conf
	}

	cat /etc/mkinitcpio.conf | grep -i HOOKS= | grep -i "modconf" > /dev/null || {
		echo "Add entry to mkinitcpio HOOKS config"
		sed -i -E 's|HOOKS=\((.*)\)|HOOKS=\(modconf \1\)|g' /etc/mkinitcpio.conf
	}

	declare iommu_groups=$(
		shopt -s nullglob
		for d in /sys/kernel/iommu_groups/*/devices/*;
		do
			n=${d#*/iommu_groups/*}; n=${n%%/*}
			printf 'IOMMU Group %s ' "$n"
			lspci -nns "${d##*/}"
		done
	)

	if [ `(echo "${iommu_groups}") | wc -l` -le 0 ];
	then
		echo "No IOMMU groups found!"
		echo "The kernel config for IOMMU should be valid. Reboot and try again to see if that works"
		return
	fi

	# /etc/modprobe.d/vfio.conf
	# options vfio-pci ids=10de:1401,10de:0fba

	echo "you may need to re-build grub, re-build initrams, log out and in, reboot, or some combo of these"
}
