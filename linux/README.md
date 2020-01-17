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

### Configure Arch (as root)

```
./configure.sh "will" # Or whatever user name
```
