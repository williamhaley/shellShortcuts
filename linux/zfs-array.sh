#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/functions.sh"

ensure_root_access

while [[ $# > 1 ]]
do
key="$1"

case $key in
    -d|--disks)
    DISKS="$2"
    shift
    ;;
    -k|--keyfile)
    KEYFILE="$2"
    shift
    ;;
    *)
      # unknown option
    ;;
esac
shift
done

if [ -z "$DISKS" ];
then
  echo "Must specify a comma separated list of block devices."
  echo ""
  echo "640g-array.sh --disks '/dev/sdb,/dev/sdc' --keyfile '/path/to/key'"
  echo ""
  exit 1
fi

IFS=',' LIST=($DISKS)

for DISK in "${LIST[@]}";
do
  if [ ! -b "$DISK" ];
  then
    echo "$DISK is not a block device."
    exit 1
  fi
done

if [ ! -f "$KEYFILE" ];
then
  echo "Must specify a keyfile."
  echo ""
  echo "640g-array.sh --disks '/dev/sdb,/dev/sdc' --keyfile '/path/to/key'"
  echo ""
  exit 1
fi

zpool destroy array1

#for DISK in "${LIST[@]}";
#do
#  wipefs --all --force $DISK
#done

bash "$CONFIG_DIR/zfs/install-zfs.sh"

# TODO WFH This is a potential huge mess.
for DISK in "${LIST[@]}";
do
  EXISTING_UUID=$(lsblk --raw $DISK | tail -1 | awk '{print $1}')

  # If already opened, close the crypt disk.
  if [ -n "$EXISTING_UUID" ];
  then
    cryptsetup close /dev/mapper/$EXISTING_UUID
  fi

  # TODO WFH Necessary?
  wipefs --all --force $DISK

  # TODO WFH Necessary?
  parted $DISK mklabel msdos -s

  cryptsetup --batch-mode -y -v luksFormat "$DISK" "$KEYFILE"
  
  UUID=$(blkid -s UUID -o value $DISK)

  cryptsetup open $DISK $UUID --key-file="$KEYFILE"

  # Create pool if not exist, or add disk to it.
  zpool create -f -m /mnt/array1 array1 /dev/mapper/$UUID || zpool add array1 /dev/mapper/$UUID

  echo "$UUID UUID=$UUID $KEYFILE" >> /etc/crypttab
done

zpool set cachefile=/etc/zfs/zpool.cache array1

echo "Done. Verify /etc/crypttab looks alright."
