_init()
{
	pacman-key --init
	pacman-key --populate archlinuxarm
}

_video()
{
	pacman -Syyu --noconfirm --needed \
		xorg xorg-server xorg-xinit xf86-video-fbdev \
		xterm lxterminal \
		numlockx \
		gnome-keyring \
		openbox obconf \
		tint2 \
		thunar tumbler ffmpegthumbnailer \
		feh gpicview \
		xscreensaver xbindkeys xdotool \
		noto-fonts noto-fonts-emoji ttf-dejavu

	su - aur-user -c "
		yay -Syyu --noconfirm \
			thunar-thumbnailers
	"
}

_nvidia()
{
	_noop
}

_wifi()
{
	pacman -Syyu --noconfirm --needed \
		wpa_supplicant
}

_audio_platform()
{
	sed -i '/dtparam=/d' /boot/config.txt
	echo "dtparam=audio=on" | tee -a /boot/config.txt

	# HDMI
	# amixer cset numid=3 2
	# Headphones
	# amixer cset numid=3 1
}

_apps_platform()
{
	pacman -Syyu --noconfirm --needed \
		linux-raspberrypi4-headers

	curl -L \
		-o /usr/local/bin/dbxcli \
		https://github.com/dropbox/dbxcli/releases/download/v2.1.2/dbxcli-linux-arm && \
	chmod +x /usr/local/bin/dbxcli
}

_kvm()
{
	_noop
}
