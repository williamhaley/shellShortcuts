Vanilla Ubuntu

```
handbrake-cli
libdvd-pkg
tree
git
ssh
vim
tmux
zfs
```

Download Plex from their site.

```
array1
backup
```

```
sudo mkdir /mnt/Plex/{Films,FilmRenders,TV,TVRenders}
```

```
# /etc/fstab

...
/mnt/array1/Videos/Masters/Films            /mnt/Plex/Films       none defaults,bind,ro,nofail,x-systemd.requires=zfs-mount.service 0 2
/mnt/array1/Videos/Masters/TV               /mnt/Plex/TV          none defaults,bind,ro,nofail,x-systemd.requires=zfs-mount.service 0 2
/mnt/array1/Videos/Renders/mkv/Film\040ISOs /mnt/Plex/FilmRenders none defaults,bind,ro,nofail,x-systemd.requires=zfs-mount.service 0 2
/mnt/array1/Videos/Renders/mkv/TV\040ISOs   /mnt/Plex/TVRenders   none defaults,bind,ro,nofail,x-systemd.requires=zfs-mount.service 0 2
```

```
# /etc/defaults/zfs

...
ZFS_MOUNT='yes'
ZFS_UNMOUNT='yes'
```

```
# from array1
./backup.sh
```
