_init()
{
	pacman-key --init
	pacman-key --populate archlinuxarm
}

_video()
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

_nvidia()
{
	_noop
}

_wifi()
{
	pacman -Syy --noconfirm --needed \
		wpa_supplicant
}

_audio()
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

_apps_platform()
{
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

_kvm()
{
	_noop
}
