#!/usr/bin/env bash

# Scriptable terminal/iTerm/bash/command line configurations/preferences/settings for Apple Mac OSX

function fonts
{
	cd /tmp
	curl -o inconsolata.zip https://fonts.google.com/download?family=Inconsolata
	unzip inconsolata.zip
	# TODO WFH Script these installs.
	open Inconsolata-Regular.ttf
	open Inconsolata-Bold.ttf
}

function screensaver
{
    /usr/bin/defaults -currentHost write com.apple.screensaver 'CleanExit' -string "YES"
    /usr/bin/defaults -currentHost write com.apple.screensaver 'PrefsVersion' -int "100"
    /usr/bin/defaults -currentHost write com.apple.screensaver 'idleTime' -int "180"
    /usr/bin/defaults -currentHost write com.apple.screensaver "moduleDict" -dict-add "path" -string "/System/Library/Frameworks/ScreenSaver.framework/Resources/Computer Name.saver"
    /usr/bin/defaults -currentHost write com.apple.screensaver "moduleDict" -dict-add "type" -int "0"
    /usr/bin/defaults -currentHost write com.apple.screensaver 'tokenRemovalAction' -int "0"
    /usr/bin/defaults write com.apple.screensaver askForPassword -bool true
    /usr/bin/defaults write com.apple.screensaver askForPasswordDelay 0
}

function menu
{
    defaults write com.apple.systemuiserver menuExtras -array \
        "/System/Library/CoreServices/Menu Extras/AirPort.menu" \
        "/System/Library/CoreServices/Menu Extras/Volume.menu" \
        "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
        "/System/Library/CoreServices/Menu Extras/Displays.menu" \
        "/System/Library/CoreServices/Menu Extras/Clock.menu"

    # Show battery percentage in menu bar
    defaults write com.apple.menuextra.battery ShowPercent -string "YES"

    # Configure date format in menu bar
    defaults write com.apple.menuextra.clock DateFormat -string "EEE MMM d  H:mm:ss"
    defaults write com.apple.menuextra.clock FlashDateSeparators -bool false
    defaults write com.apple.menuextra.clock IsAnalog -bool false

    killall SystemUIServer
}

function preferences
{
    # https://github.com/joeyhoer/starter/blob/master/system/sound.sh
    # Play feedback when volume is changed
    defaults write NSGlobalDomain com.apple.sound.beep.feedback -bool true

    # Double click the titlebar to maximize a window
    defaults write NSGlobalDomain AppleActionOnDoubleClick -string "Maximize"

	defaults write com.apple.Terminal.plist "Default Window Settings" "Pro"
	defaults write com.apple.Terminal.plist "Startup Window Settings" "Pro"
	defaults write com.apple.Terminal.plist."Window Settings.Pro"
	/usr/libexec/PlistBuddy -c "Set \"Window Settings\":Pro:shellExitAction 0" ~/Library/Preferences/com.apple.Terminal.plist

	echo "Start and completely exist Terminal **twice** for settings to take effect"
}


fonts
screensaver
menu
preferences


