#!/bin/bash

# Get this using `diskutil list | grep NAMEOFUSBDRIVE` to get the disk number.
# Then, `diskutil info DISKNUMBER | grep "Volume UUID"` to get the UUID.
USB_KEY_UUID=''

# Get this using `diskutil corestorage list | grep "Logical Volume"`
ENCRYPTED_VOLUME_UUID=''

LOG=/tmp/mount.log

echo "mount attempted at $(date)" > $LOG 2>&1

# Must ensure the USB key is mounted so we can access the key file.
diskutil mount $USB_KEY_UUID >> $LOG 2>&1

diskutil list >> $LOG 2>&1

KEY_NAME=$(diskutil info $USB_KEY_UUID | grep "Volume Name" | awk '{print $3}')

echo $KEY_NAME >> $LOG 2>&1

# Read the key.
password=$(cat /Volumes/$KEY_NAME/willencryptedhome.key)

# Mount encrypted volume using the key.
printf $password|diskutil corestorage unlockVolume $ENCRYPTED_VOLUME_UUID -stdinpassphrase

# This looks odd, but I've found that occasionally it fails to unmount the first
# time, so adding a loop so we can re-try.
MAX_ATTEMPTS=10
ATTEMPT=0
while [ "$(diskutil info $ENCRYPTED_VOLUME_UUID | grep -i "Mounted" | awk '{print $2}')" == 'Yes' ] && [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
  sleep 1
  echo "$ENCRYPTED_VOLUME_UUID is mounted. Attempt: $ATTEMPT of $MAX_ATTEMPTS" >> $LOG 2>&1
  diskutil umount $ENCRYPTED_VOLUME_UUID >> $LOG 2>&1
  ATTEMPT=$((ATTEMPT+1))
done

diskutil mount -mountPoint /Users/will $ENCRYPTED_VOLUME_UUID >> $LOG 2>&1
