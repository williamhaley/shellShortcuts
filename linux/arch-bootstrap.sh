#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

LOCALE_GEN='en_US.UTF-8 UTF-8'
LOCALE_CONF='LANG=en_US.UTF-8'
TIMEZONE='/usr/share/zoneinfo/US/Central'
APPLICATIONS='bash-completion git iw openssh'
MIRROR='http://mirror.us.leaseweb.net/archlinux/$repo/os/$arch'
ARCH_HOSTNAME='archlinux'
ENCRYPTION_KEYFILE='/mnt/boot/key.keyfile'

# Traps for signals.

function finish
{
	echo "Finished. Clean up..."
	umount /mnt/boot || true
	umount /key || true
	umount /mnt || true
	cryptsetup luksClose cryptroot || true
}

function interrupt
{
	echo "Script interrupted."
	exit 1
}

trap interrupt INT
trap finish EXIT

# Helpers.

function print_help
{
	echo "Usage: /bin/bash bootstrap.sh --disk=disk --name=name"
	echo
	echo "     --disk       Required. The disk on which to install Arch."
	echo "                  e.g. --disk=/dev/sda"
	echo
	echo "     --name       Required. The name of the initial user."
	echo "                  e.g. --name=will"
	exit 1
}

# Check user input.

if [ $# -lt 1 ];
then
	print_help
	exit 1
fi

while [ $# -gt 0 ]; do
	case "$1" in
		--disk=*)
			DISK="${1#*=}"
			BOOT_PART=${DISK}1
			KEY_PART=${DISK}2
			ROOT_PART=${DISK}3
			;;
		--name=*)
			USERNAME="${1#*=}"
			;;
		*)
			print_help
			exit 1
	esac
	shift
done

# Set our mirror.
echo "Server = $MIRROR" > /etc/pacman.d/mirrorlist

# Crude method for wiping out partition tables.
dd if=/dev/zero of=$DISK bs=1M count=100
parted --script $DISK mklabel msdos

# Create boot partition 1GB large.
echo -e "o\nn\np\n1\n\n+1000M\nw" | fdisk $DISK
sleep 3

# Create key partition 10MB large.
echo -e "n\np\n2\n\n+10M\nw" | fdisk $DISK
sleep 3

# Create root partition using remaining space.
echo -e "n\np\n3\n\n\nw" | fdisk $DISK
sleep 3

# Make boot partition bootable.
echo -e "a\n1\nw" | fdisk $DISK
sleep 3

# Format boot partition.
mkfs.ext4 -F $BOOT_PART

# Format key partition.
mkfs.vfat $KEY_PART
# Mount key partition.
mkdir -p /key
mount $KEY_PART /key

# Encrypt and format root partition.
dd if=/dev/urandom bs=512 count=24 | tr -dc _A-Z-a-z-0-9 | head -c 4096 | dd of=/key/key.keyfile
cryptsetup --batch-mode -y -v luksFormat $ROOT_PART /key/key.keyfile
cryptsetup open $ROOT_PART cryptroot --key-file="/key/key.keyfile"
mkfs.ext4 -F /dev/mapper/cryptroot
mount /dev/mapper/cryptroot /mnt

mkdir /mnt/boot
mount $BOOT_PART /mnt/boot

## System configuration.

pacstrap /mnt base

genfstab -U -p /mnt >> /mnt/etc/fstab

# Hook for encryption.
sed -i -e "s|HOOKS=\(.*\)filesystems\(.*\)|HOOKS=\1encrypt filesystems\2|" /mnt/etc/mkinitcpio.conf

# Allow loading keyfile from vfat or ext4 USB.
sed -i -e "s|MODULES=\"\(.*\)\"|MODULES=\"\1nls_cp437 vfat ext4\"|" /mnt/etc/mkinitcpio.conf

# Hostname.
arch-chroot /mnt /bin/bash -c "echo '$ARCH_HOSTNAME' > /etc/hostname"

# Enable DHCP.
arch-chroot /mnt systemctl enable dhcpcd

# Timezone.
arch-chroot /mnt ln -sf $TIMEZONE /etc/localtime

# Apps to install.
arch-chroot /mnt /bin/bash -c "pacman -S --noconfirm $APPLICATIONS"

# Locale.
echo "$LOCALE_GEN" > /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
echo "$LOCALE_CONF" > /mnt/etc/locale.conf
arch-chroot /mnt locale-gen

# Sudoers config.
arch-chroot /mnt pacman -S --noconfirm sudo
echo "root    ALL=(ALL) ALL" > /mnt/etc/sudoers
echo "%sudo   ALL=(ALL) ALL" >> /mnt/etc/sudoers
arch-chroot /mnt groupadd sudo
arch-chroot /mnt chmod 440 /etc/sudoers

# Add initial user.
arch-chroot /mnt useradd -m -s /bin/bash -G sudo $USERNAME

# Blank out the root password. Sudo will be the only way to get root access!!!
arch-chroot /mnt passwd -l root

# Firewall will deny everything by default.
arch-chroot /mnt pacman -S --noconfirm ufw
arch-chroot /mnt ufw default deny
# This enables the service, but does *not* enable ufw. Only `ufw enable` will
# do that, and it cannot be done in chroot.
arch-chroot /mnt systemctl enable ufw
mkdir -p /mnt/etc/ufw
echo "ENABLED=yes" > /mnt/etc/ufw/ufw.conf
echo "LOGLEVEL=low" >> /mnt/etc/ufw/ufw.conf

# Grub.
arch-chroot /mnt mkinitcpio -p linux
arch-chroot /mnt pacman -S --noconfirm grub

ROOT_PART_UUID="$(blkid -s UUID -o value $ROOT_PART)"
KEY_MOUNT=$(stat -c %m -- "/key/key.keyfile")
KEY_RELATIVE_PATH=$(echo /key/key.keyfile|sed "s|^$KEY_MOUNT||")
KEY_PART_DEV=$(df -P "$KEY_MOUNT" | tail -1 | cut -d' ' -f 1)
KEY_PART_UUID=$(blkid -s UUID -o value $KEY_PART_DEV)

sed -i -e "s|GRUB_CMDLINE_LINUX=\"\(.*\)\"|GRUB_CMDLINE_LINUX=\"\1cryptdevice=UUID=$ROOT_PART_UUID:cryptroot root=/dev/mapper/cryptroot cryptkey=UUID=$KEY_PART_UUID:vfat:$KEY_RELATIVE_PATH\"|" /mnt/etc/default/grub

arch-chroot /mnt grub-install --target=i386-pc --recheck --debug $DISK
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

clear

echo
echo "************************************************"
echo "You *must* set a password for user: $USERNAME"
echo "This is the only user who will have access."
echo "************************************************"
echo
arch-chroot /mnt passwd $USERNAME
echo
echo "Done. Please reboot."
