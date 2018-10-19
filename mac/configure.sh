#!/usr/bin/env bash

function screensaver
{
	/usr/bin/defaults -currentHost write com.apple.screensaver 'CleanExit' -string "YES"
	/usr/bin/defaults -currentHost write com.apple.screensaver 'PrefsVersion' -int "100"
	/usr/bin/defaults -currentHost write com.apple.screensaver 'idleTime' -int "60"
	/usr/bin/defaults -currentHost write com.apple.screensaver "moduleDict" -dict-add "path" -string "/System/Library/Frameworks/ScreenSaver.framework/Resources/Computer Name.saver"
	/usr/bin/defaults -currentHost write com.apple.screensaver "moduleDict" -dict-add "type" -int "0" 
	/usr/bin/defaults -currentHost write com.apple.screensaver 'tokenRemovalAction' -int "0"
}

function menuicons
{
	defaults write com.apple.systemuiserver menuExtras -array \
		"/System/Library/CoreServices/Menu Extras/AirPort.menu" \
		"/System/Library/CoreServices/Menu Extras/Volume.menu" \
		"/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
		"/System/Library/CoreServices/Menu Extras/Displays.menu" \
		"/System/Library/CoreServices/Menu Extras/Clock.menu"

	killall SystemUIServer
}

function preferences
{
	# https://github.com/joeyhoer/starter/blob/master/system/sound.sh
	# Play feedback when volume is changed
	defaults write NSGlobalDomain com.apple.sound.beep.feedback -bool true
}

function dock
{
	defaults write com.apple.Dock orientation -string right
	defaults write com.apple.dock pinning -string end

	defaults delete com.apple.dock persistent-apps
	defaults write com.apple.dock persistent-apps -array

	#defaults write com.apple.dock persistent-apps -array-add \
	#	"<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/VLC.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"

	killall Dock
}

screensaver
menuicons
preferences
dock

