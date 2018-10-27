# Philosophy

If you can't install it from the App Store or Homebrew, then don't.

Try to keep this as pristine as possible. Avoid clutter.

# Configure

Install Xcode from the App Store and then install [Homebrew](http://brew.sh/).

```
./install.sh
./configure.sh
```

# Encrypted $HOME

Setup full disk encryption with Filevault or at least an encrypted $HOME with Apple coldstorage.

Make sure USB key is exFat MBR if doing an encrypted $HOME.

```
sudo cp ./com.willhaley.mac.startup.plist /Library/LaunchDaemons/
sudo cp ./startup.sh /opt/
sudo chmod +x /opt/startup.sh
sudo chmod 600 /opt/startup.sh
```

# TODO Call mount.sh from startup.sh

Update the variables at the top of `/opt/startup.sh`.

```
launchctl load -w /Library/LaunchDaemons/com.willhaley.mac.startup.plist
```

```
# http://nicolasgallagher.com/mac-osx-bootable-backup-drive-with-rsync/
# CLOSE OUT OF *EVERYTHING* BEFORE SYNCING.
sudo rsync --acls --archive --delete --hard-links --sparse --verbose --xattrs ~/ /Volumes/WILLENCRYPTEDHOME/
```

```
diskutil secureErase freespace 0 disk1s2
```

```
(cd ~/ && tree -a -s ./ > /tmp/local.txt)
(cd /Volumes/WILLENCRYPTEDHOME && tree -a -s ./ > /tmp/encrypted.txt)
git diff /tmp/local.txt /tmp/encrypted.txt
```

Note, some services like Dropbox are clever enough to know the drive changed, and will ask you to re-authenticate, but for the most part you should be good to go.

