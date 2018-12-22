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

aur()
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

bluetooth()
{
    # https://wiki.archlinux.org/index.php/Bluetooth_headset#Headset_via_Bluez5.2Fbluez-alsa

    pacman -Syy --needed --noconfirm \
        pulseaudio pulseaudio-bluetooth pavucontrol bluez bluez-utils

    systemctl start bluetooth
    systemctl enable bluetooth
}

video()
{
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

    sed -i '/gpu_mem=/d' /boot/config.txt
    echo "gpu_mem=128" | tee -a /boot/config.txt
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
    pacman -Syy --noconfirm --needed \
	    wpa_supplicant
}

sshd()
{
    pacman -S --noconfirm --needed \
	    openssh

    groupadd sshusers || true
    ufw allow 22

    cat <<'EOF' >/etc/ssh/sshd_config
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

audio()
{
    pacman -Sy --noconfirm --needed \
        alsa-firmware alsa-plugins alsaplayer

    sed -i '/dtparam=/d' /boot/config.txt
    echo "dtparam=audio=on" | tee -a /boot/config.txt

    # HDMI
    # amixer cset numid=3 2
    # Headphones
    # amixer cset numid=3 1
}

apps()
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

    cat <<'EOF' >/etc/profile.d/go.sh
export PATH=$PATH:/usr/local/go/bin
export GOPATH=/usr/local/go
EOF

    source /etc/profile.d/go.sh

    go get github.com/git-lfs/git-lfs

	 curl -L \
		-o /usr/local/bin/dbxcli \
		https://github.com/dropbox/dbxcli/releases/download/v2.1.2/dbxcli-linux-arm && \
	chmod +x /usr/local/bin/dbxcli

	yay -Syy --noconfirm --needed \
		hangups
}

if [ -n "${1}" ];
then
    ${1}
else
    init
    locale
    sudo
    aur # depends on sudo
    firewall
    audio
    video
    wifi
    sshd # depends on firewall. Run after so we can add exception for port 22.
    apps
    bluetooth

    # useradd -m -s /bin/bash -G sshusers,docker,sudo will || true
    # usermod -a -G sshusers,docker,sudo will || true
    # passwd will
fi

