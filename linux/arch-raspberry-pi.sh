#!/usr/bin/env bash

[ $EUID -ne 0 ] && echo "run as root" >&2 && exit 1

init()
{
    pacman-key --init
    pacman-key --populate archlinuxarm
}

locale()
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

sudo()
{
    pacman -Syy --noconfirm --needed \
        sudo

    cat <<'EOF' > /etc/sudoers
root    ALL=(ALL) ALL
%sudo   ALL=(ALL) ALL

#includedir /etc/sudoers.d
EOF

    chmod 440 /etc/sudoers
    chown root:root /etc/sudoers
    groupadd sudo
}

user()
{
    local username=$1

    if [ -z ${username} ];
    then
        echo "user() func needs a username as an argument"
    fi

    cat /etc/passwd | grep ${username} >/dev/null 2>&1
    if [ $? -ne 0 ];
    then
        useradd -m -s /bin/bash -G sudo ${username}
    fi
    usermod -a -G sudo ${username} || true
    if getent shadow | grep '^[^:]*:.\?:' | cut -d: -f1 | grep -w ${username} >/dev/null 2>&1;
    then
        passwd ${username}
    fi
}

aur-helper()
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
    sudo -u aur-user -- sh -c "
        rm -rf /tmp/package-query
        mkdir -p /tmp/package-query
        cd /tmp/package-query
        wget https://aur.archlinux.org/cgit/aur.git/snapshot/package-query.tar.gz
        tar zxvf package-query.tar.gz
        cd package-query
        makepkg --syncdeps --rmdeps --install --noconfirm
    "

    # yay
    sudo -u aur-user -- sh -c "
        rm -rf /tmp/yay
        mkdir -p /tmp/yay
        cd /tmp/yay
        wget https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz
        tar zxvf yay.tar.gz
        cd yay
        makepkg --syncdeps --rmdeps --install --noconfirm
    "
}

bluetooth()
{
    # https://wiki.archlinux.org/index.php/Bluetooth_headset#Headset_via_Bluez5.2Fbluez-alsa

    # expect is here for the sake of scripting bluetooth connections.
    pacman -Syy --needed --noconfirm \
        pulseaudio pulseaudio-bluetooth pavucontrol bluez bluez-utils expect

    systemctl start bluetooth
    systemctl enable bluetooth
}

x()
{
    # non-arm - doesn't need xf86-video-fbdev
    pacman -Syy --noconfirm --needed \
        xorg xorg-server xorg-xinit xf86-video-fbdev \
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

firewall()
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

wifi()
{
    # non-arm - linux-headers broadcom-wl-dkms

    pacman -Syy --noconfirm --needed \
	    wpa_supplicant
}

sshd()
{
    local username=$1

    if [ -z ${username} ];
    then
        echo "sshd() func needs a username as an argument"
    fi

    pacman -S --noconfirm --needed \
	    openssh

    groupadd sshusers || true
    usermod -a -G sshusers ${username} || true
    ufw allow 22

    cat <<'EOF' >
PermitRootLogin                 no

UsePAM                          yes
PrintMotd                       no

ClientAliveInterval             0
ClientAliveCountMax             0

AuthorizedKeysFile              /home/%u/.ssh/authorized_keys

ChallengeResponseAuthentication no
PasswordAuthentication          yes
PermitEmptyPasswords            no

UsePrivilegeSeparation          sandbox
StrictModes                     yes

Subsystem                       sftp    internal-sftp

AllowGroups                     sshusers

EOF

    chmod 644 /etc/ssh/sshd_config
    chown root:root /etc/ssh/sshd_config

    systemctl enable sshd
    systemctl start sshd
}

apps()
{
    local username=$1

    if [ -z ${username} ];
    then
        echo "apps() func needs a username as an argument"
    fi

    # non-arm - handbrake handbrake-cli vagrant virtualbox intel-ucode memtest86+ rclone syslinux
    # non-arm needs vboxusers group too

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
        alsa-utils pulseaudio pavucontrol \
        qemu qemu-arch-extra virt-viewer \
        docker docker-compose \
        electrum \
        libdvdcss dvdbackup cdrkit \
        vlc cmus mplayer sound-juicer \
        xfburn gst-plugins-good gst-plugins-base gst-plugins-bad gst-plugins-ugly \
        fbida ranger w3m \
        expect \
        ack \
        vim

    usermod -a -G docker ${username}

    systemctl enable docker
    systemctl start docker
}

init
locale
sudo
aur-helper # depends on sudo running first
bluetooth
user will # depends on sudo running first. Will prompt for a password.
# firewall
x
wifi
sshd will