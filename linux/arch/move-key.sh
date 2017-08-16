#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

function finish
{
	umount /tmp/mnt1 || true
	umount /tmp/mnt2 || true
}

trap finish EXIT

USB_DISK=${1:-}

if [ -z "$USB_DISK" ];
then
	echo "Pass in a USB disk. It will be wiped! (e.g. /dev/sde)"
	exit 1
fi

KEY_PART=$(cat /proc/mounts | grep /boot | awk '{print $1}' | sed 's/.$/2/')
USB_PART=${USB_DISK}1

mkdir -p /tmp/mnt1
mkdir -p /tmp/mnt2

dd if=/dev/zero of=$USB_DISK bs=1M count=100
parted --script $USB_DISK mklabel msdos
echo -e "o\nn\np\n1\n\n\nw" | fdisk $USB_DISK
sleep 3
mkfs.vfat $USB_PART
sleep 3

mount $KEY_PART /tmp/mnt1
mount $USB_PART /tmp/mnt2

cp /tmp/mnt1/key.keyfile /tmp/mnt2/

sync

OLD_BLKID=$(blkid -s UUID -o value $KEY_PART)
NEW_BLKID=$(blkid -s UUID -o value $USB_PART)

sed -i "s|cryptkey=UUID=${OLD_BLKID}|cryptkey=UUID=${NEW_BLKID}|g" /etc/default/grub

grub-mkconfig -o /boot/grub/grub.cfg
