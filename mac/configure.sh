#!/usr/bin/env bash

# Scriptable terminal/iTerm/bash/command line configurations/preferences/settings for Apple Mac OSX

function screensaver
{
	/usr/bin/defaults -currentHost write com.apple.screensaver 'CleanExit' -string "YES"
	/usr/bin/defaults -currentHost write com.apple.screensaver 'PrefsVersion' -int "100"
	/usr/bin/defaults -currentHost write com.apple.screensaver 'idleTime' -int "60"
	/usr/bin/defaults -currentHost write com.apple.screensaver "moduleDict" -dict-add "path" -string "/System/Library/Frameworks/ScreenSaver.framework/Resources/Computer Name.saver"
	/usr/bin/defaults -currentHost write com.apple.screensaver "moduleDict" -dict-add "type" -int "0"
	/usr/bin/defaults -currentHost write com.apple.screensaver 'tokenRemovalAction' -int "0"
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

	# Show indicator lights for open applications in the Dock
	defaults write com.apple.dock show-process-indicators -bool true

	# Minimize windows into their application’s icon
	defaults write com.apple.dock minimize-to-application -bool true
}

function dock
{
	defaults write com.apple.dock autohide -bool false
	defaults write com.apple.dock largesize -int 64
	defaults write com.apple.dock magnification -bool false
	defaults write com.apple.dock mineffect -string 'scale'
	defaults write com.apple.Dock orientation -string right
	defaults write com.apple.dock pinning -string end
	defaults write com.apple.dock size-immutable -bool true
	defaults write com.apple.dock tilesize -int 46

	# Make Dock icons of hidden applications translucent
	defaults write com.apple.dock showhidden -bool true

	# Delete all persistent apps from the dock
	defaults delete com.apple.dock persistent-apps
	# Initialize an empty array of persistent apps for the dock
	defaults write com.apple.dock persistent-apps -array

	# This is how one could add a persistent app to the dock
	#defaults write com.apple.dock persistent-apps -array-add \
	#	"<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/VLC.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"

	killall Dock
}

screensaver
menu
preferences
dock

