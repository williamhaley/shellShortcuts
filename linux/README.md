# Linux

## Bootstrap Arch

Boot from the live installation media.

```
curl -O https://raw.githubusercontent.com/williamhaley/configs/master/linux/arch-bootstrap.sh
bash arch-bootstrap.sh --disk=/dev/sda --name=will
```

Reboot your machine and eject the live media.

## Configure

Clone this repo to the machine.

### Arch (as root)

This is most likely what you want. You can re-run these commands individually or add more.

```
./configure.sh apps audio aur firewall init locale sudo video
```

Other commands not listed above include `bluetooth`, `kvm`, `nvidia`, `sshd`. See `configure.sh` for all possible commands.

Add the user to groups as needed. For example.

```
usermod -a -G sshusers,docker,sudo,vboxusers will
```

