# Alpine

```
apk add dhcpcd
dhcpcd
wget https://raw.githubusercontent.com/williamhaley/configs/master/linux/alpine/answers.txt
```

The script will prompt for the `root` password as well as the disk to install to. Everything else should be automated.

```
setup-alpine -f answers.txt
reboot
```

Install the base applications.

Edit `/etc/apk/repositories` to enable all the repositories for the mirror. Simply uncomment the other repositories. By default, only `main` is enabled.

```
setup-xorg-base
apk add virtualbox-guest-additions virtualbox-guest-modules-virt
apk add font-noto
apk add libinput i3 i3status

# Adding this borked it all?! Yeah, deleting this and i3 then re-installing i3 fixes :-/
# i3wm-gaps
# Does removing nomodeset magically fix it :D

# dbus dbus-x11 xf86-input-synaptics lxdm
# rc-service dbus start
# rc-update add dbus terminus-font
```

```
cat <<'EOF' >~/.xinitrc
#!/bin/sh

i3
EOF
