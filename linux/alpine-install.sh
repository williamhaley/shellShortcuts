#!/usr/bin/env bash

set -e

applications="cryptsetup bash sudo wireless-tools wpa_supplicant vim curl geany xterm firefox font-noto font-noto-emoji openbox"
root_format="ext4"

# Traps for signals.

finish()
{
	echo "Finished. Clean up..."
	umount /mnt || true
}

interrupt()
{
	echo "Script interrupted."
	exit 1
}

trap interrupt INT
trap finish EXIT

# Helpers.

print_help()
{
	echo "Usage: /bin/bash alpine-install.sh --disk=disk --name=name"
	echo
	echo "     --disk       Required. The disk on which to install."
	echo "                  e.g. --disk=/dev/sda"
	echo
	echo "     --name       Required. The name of the initial user."
	echo "                  e.g. --name=will"
	exit 1
}

############
# 0. Input #
############

if [ $# -lt 1 ];
then
	print_help
	exit 1
fi

while [ $# -gt 0 ]; do
	case "$1" in
		--disk=*)
			disk="${1#*=}"
			boot_part=${disk}1
			swap_part=${disk}2
			root_part=${disk}3
			;;
		--name=*)
			username="${1#*=}"
			;;
		--key=*)
			use_existing_key=true
			key_path="${1#*=}"
			;;
		*)
			print_help
			exit 1
	esac
	shift
done

if [ -z "${username}" ];
then
	echo "Must pass --name"
	echo
	print_help
	echo
	exit 1
fi

if [ -z "${disk}" ];
then
	echo "Must pass --disk"
	echo
	print_help
	echo
	exit 1
fi

##############
# 1. Disks #
##############

dd if=/dev/random of=${disk} bs=2048 count=1
echo "o\nw\n" | fdisk ${disk}

# Create boot partition 100M large.
echo -e "o\nn\np\n1\n\n+100M\nw" | fdisk ${disk}
sleep 3

# Create swap partition.
echo -e "n\np\n2\n\n+4G\nt\n2\n82\nw" | fdisk ${disk}
mkswap ${swap_part}
sleep 3

# Create root partition using remaining space.
echo -e "n\np\n3\n\n\nw" | fdisk ${disk}
sleep 3

# Make boot partition bootable.
echo -e "a\n1\nw" | fdisk ${disk}
sleep 3

# Format boot partition.
mkfs.${root_format} -F ${boot_part}

###################
# 2. Encrypt root #
###################

# Encrypt and format root partition.
cryptsetup -v luksFormat ${root_part}
cryptsetup open ${root_part} cryptroot
mkfs.${root_format} -F /dev/mapper/cryptroot
mount /dev/mapper/cryptroot /mnt

mkdir /mnt/boot
mount -t ext4 ${boot_part} /mnt/boot

######################################
# 3. Base system install and config  #
######################################

answers=`mktemp`

# If we wanted, we could hand-feed these options to each command that gets
# called by setup-alpine, but it's a bit more mainline to have this one single
# answers file.
cat <<EOF >$answers
KEYMAPOPTS="us us"
HOSTNAMEOPTS="-n localhost"
INTERFACESOPTS="auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
    hostname alpine-test
"

DNSOPTS="-n 1.1.1.1"
TIMEZONEOPTS="-z America/Chicago"
PROXYOPTS="none"
APKREPOSOPTS="-1"

SSHDOPTS="-c openssh"
NTPOPTS="-c openntpd"

DISKOPTS="-m sys ${disk}"
EOF

setup-alpine -f "${answers}"

mount "${root_part}" /mnt

sed -i'' 's|#http|http|g' /mnt/etc/apk/repositories
chroot /mnt apk update
chroot /mnt apk add ${applications}
echo "root    ALL=(ALL) ALL" > /mnt/etc/sudoers
echo "%sudo   ALL=(ALL) ALL" >> /mnt/etc/sudoers
chroot /mnt chmod 440 /etc/sudoers
chroot /mnt adduser -s /bin/bash ${username}
chroot /mnt addgroup sudo
chroot /mnt addgroup ${username} sudo

cat <<'EOF' >/mnt/home/${username}/.xinitrc
#!/bin/sh

openbox
EOF

cat <<'EOF' >/mnt/etc/profile.d/post_install.sh
#!/bin/sh

echo "+----------------------------------------------+"
echo "|                                              |"
echo "| run setup-xorg-base to finish installing X   |"
echo "|                                              |"
echo "| then clean up /etc/profile.d/post_install.sh |"
echo "|                                              |"
echo "+----------------------------------------------+"
EOF

cat <<'EOF' >/mnt/usr/local/bin/wifi
#!/bin/sh

ip link
ip link set wlan0 up
iwlist wlan0 scanning
iwconfig wlan0 essid ExampleWifi
iwconfig wlan0
wpa_passphrase 'ExampleWifi' 'ExampleWifiPassword' > /etc/wpa_supplicant/wpa_supplicant.conf

#wpa_supplicant -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf
wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf
udhcpc -i wlan0
ip addr show wlan0
EOF
chmod +x /mnt/usr/local/bin/wifi

cat <<'EOF' >/mnt/etc/xdg/openbox/menu.xml
<?xml version="1.0" encoding="UTF-8"?>
<openbox_menu xmlns="http://openbox.org/3.4/menu">
	<menu id="apps-net-menu" label="Internet">
	<item label="Firefox">
		<action name="Execute">
		<command>firefox</command>
		<startupnotify>
			<enabled>yes</enabled>
			<wmclass>Firefox</wmclass>
		</startupnotify>
		</action>
	</item>
	</menu>
	<menu id="system-menu" label="System">
	<item label="Openbox Configuration Manager">
		<action name="Execute">
		<command>obconf</command>
		<startupnotify><enabled>yes</enabled></startupnotify>
		</action>
	</item>
	<separator />
	<item label="Reconfigure Openbox">
		<action name="Reconfigure" />
	</item>
	</menu>
	<menu id="root-menu" label="Openbox 3">
	<separator label="Applications" />
	<menu id="apps-net-menu"/>
	<separator label="Quick Access" />
	<item label="Terminal">
		<action name="Execute">
		<command>xterm</command>
		<startupnotify>
			<enabled>yes</enabled>
		</startupnotify>
		</action>
	</item>
	<separator label="System" />
	<menu id="system-menu"/>
	<separator />
	<item label="Log Out">
		<action name="Exit">
		<prompt>yes</prompt>
		</action>
	</item>
	</menu>
</openbox_menu>
EOF
