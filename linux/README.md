# Linux

## Arch

### Install

Boot from the live installation media.

```
curl -O https://gh.willhy.com/f/arch-install.sh
bash arch-install.sh --disk=/dev/sda --name=will
```

Reboot your machine and eject the live media.

### Configure

Clone this repo to the machine.

```
./configure.sh "will" # Or whatever user name
```

### Troubleshooting Arch

If the live environment for bootstrapping Arch has a misaligned clock or other issues, there may be problems with signatures and package validity. Check and try some of the following if necessary.

```
# Checking/setting the clock
date
date --set="<valid format>"

# See if you can install a package without problems
pacman -S ffmpeg

# Try fixing the keys in the live environment
pacman-key --populate archlinux
pacman -Sy archlinux-keyring
pacman-key --refresh-keys
```

## Alpine

Boot from the live installation media.

```
apk add dhcpcd
dhcpcd
wget https://gh.willhy.com/f/alpine-install.sh
sh ./alpine-install.sh --disk=/dev/sda --name=will
```

Reboot your machine and eject the live media.
