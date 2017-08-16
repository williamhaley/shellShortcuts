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

```
USERNAME=will ./base/arch.sh
```

Run other config scripts as needed.

```
./ufw/arch.sh
SSHUSER=will ./sshd/arch.sh
./nfsd/arch.sh
./x/arch.sh
./nvidia/arch.sh
USERNAME=will ./user/arch.sh
```
