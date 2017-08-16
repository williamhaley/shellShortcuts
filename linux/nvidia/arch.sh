#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

if [[ $EUID -ne 0 ]];
then
	echo "This script must be run as root" 1>&2
	exit 1
fi

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

pacman -S --noconfirm --needed \
	nvidia nvidia-libgl
