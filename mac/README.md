# Philosophy

If you can't install it from the App Store or Homebrew, then don't.

Try to keep this as pristine as possible. Avoid clutter.

# Install Homebrew

[Homebrew](http://brew.sh/)

```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

# Scripted configuration

It is possible to use AppleScript or bash to configure settings, but kind of a nightmare.

AppleScript requires access to accessibility, which is fine, unless a malicious script runs on your machine.

The bash scripts, `/usr/libexec/PlistBuddy`, and `defaults` _can_ work, but seem hit or miss to me.

Best bet is to configure by hand.

Here are some sample scripts though.

```
# config.scpt
tell application "System Preferences"
	reveal anchor "General" of pane id "com.apple.preference.security"
	tell application "System Events" to tell process "System Preferences"
		click checkbox "Require password" of tab group 1 of window "Security"
	end tell
	quit
end tell
```

```
defaults -currentHost read com.apple.screensaver
```

# Install apps

Install XCode, then...

```
./install.sh
```

# Configure
  
* Select the correct audio output device.
* Show on-screen-display for volume changes.
* Play sound effect for volume changes.
* Load iTerm2 preferences from `configs`. 
* Login to the App Store
* Login to iTunes
* Setup whatever configs are needed using this repo.
* Enable the firewall under security.
* Change duration for password requirement on lock/screensaver to "immediately" under security.
* Set the screen saver to start after 5 minutes.
* Disable sleeping (set the time interval to "Never").

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

