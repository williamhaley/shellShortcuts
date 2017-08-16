#!/usr/bin/env bash

ISO=$1

if [ ! -f "$ISO" ];
then
	echo "Must pass path to Arch ISO."
	exit 1
fi

if [ $EUID -ne 0 ];
then
	echo "Must run as root."
	exit 1
fi

sudo pacman -S --noconfirm --needed rsync squashfs-tools arch-install-scripts cdrkit

ID=$(date +%s%N)

MOUNTED_ISO="$(pwd)/arch-iso-$ID"
SCRATCH="$(pwd)/arch-scratch-$ID"

NAME=$(blkid -o value -s LABEL "$ISO")

OUTPUT="$(pwd)/arch-$NAME-$ID.iso"

# Mount.

mkdir -p "$MOUNTED_ISO"
mount -t iso9660 -o loop "$ISO" "$MOUNTED_ISO"

# Extract files.

cp -a "$MOUNTED_ISO" "$SCRATCH"

unsquashfs -d "$SCRATCH/arch/x86_64/squashfs-root" "$SCRATCH/arch/x86_64/airootfs.sfs"

# Prep pacman.

# Start generating entropy for pacman.
arch-chroot "$SCRATCH/arch/x86_64/squashfs-root" /bin/sh -c "haveged -w 1024; pacman-key --init; pkill -x haveged"
arch-chroot "$SCRATCH/arch/x86_64/squashfs-root" pacman-key --populate archlinux
arch-chroot "$SCRATCH/arch/x86_64/squashfs-root" pacman -Sy

###################################################################

# My customization.

# Install git.
arch-chroot "$SCRATCH/arch/x86_64/squashfs-root" pacman -S --noconfirm --needed git

# Clone my configuration repo.
arch-chroot "$SCRATCH/arch/x86_64/squashfs-root" git clone https://github.com/williamhaley/configs.git /root/configs

# Enable sshd.
arch-chroot "$SCRATCH/arch/x86_64/squashfs-root" systemctl enable sshd

# Set a root password.
echo "root:root"|arch-chroot "$SCRATCH/arch/x86_64/squashfs-root" chpasswd

###################################################################

# If kernel updates are required.

# pacman -Syu --force archiso linux
# nano /etc/mkinitcpio.conf
# HOOKS="base udev memdisk archiso_shutdown archiso archiso_loop_mnt archiso_pxe_common archiso_pxe_nbd archiso_pxe_http archiso_pxe_nfs archiso_kms block pcmcia filesystems keyboard"
# mkinitcpio -p linux

# Clean up.

# TODO Supposed to have `LANG=C ` before `pacman` on this one line.
# Won't work as command line arg though.
arch-chroot "$SCRATCH/arch/x86_64/squashfs-root" pacman -Sl | awk '/\[installed\]$/ {print $1 "/" $2 "-" $3}' > "$SCRATCH/arch/x86_64/pkglist.txt"
arch-chroot "$SCRATCH/arch/x86_64/squashfs-root" pacman -Scc --noconfirm

# If kernel updates were done.

# cp squashfs-root/boot/vmlinuz-linux ~/customiso/arch/boot/x86_64/vmlinuz
# cp squashfs-root/boot/initramfs-linux.img ~/customiso/arch/boot/x86_64/archiso.img

# Other stuff (?)
mv "$SCRATCH/arch/x86_64/pkglist.txt" "$SCRATCH/arch/x86_64/pkglist.x86_64.txt"

# Rebuild squashfs.

rm "$SCRATCH/arch/x86_64/airootfs.sfs"
mksquashfs "$SCRATCH/arch/x86_64/squashfs-root" "$SCRATCH/arch/x86_64/airootfs.sfs"
rm -r "$SCRATCH/arch/x86_64/squashfs-root"
md5sum "$SCRATCH/arch/x86_64/airootfs.sfs" > "$SCRATCH/arch/x86_64/airootfs.md5"

# Rebuild ISO.

genisoimage -l -r -J -V "$NAME" -b "isolinux/isolinux.bin" -no-emul-boot -boot-load-size 4 -boot-info-table -c "isolinux/boot.cat" -o "$OUTPUT" "$SCRATCH"

# Clean up.

umount "$MOUNTED_ISO"
rm -rf "$MOUNTED_ISO"
rm -rf "$SCRATCH"
