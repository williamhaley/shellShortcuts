#!/usr/bin/env bash

if ! [ -d "/Applications/Xcode.app" ];
then
	echo "install xcode via the store"
	exit 1
fi

xcode-select --install

brew install \
	qemu \
	ffmpeg \
	jq \
	tmux \
	rsync \
	golang

brew cask install \
	1password \
	caffeine \
	firefox \
	gimp \
	google-chrome \
	google-backup-and-sync \
	slack \
	vagrant \
	virtualbox \
	visual-studio-code \
	vlc

# Install the App, not just binaries.
brew cask install docker
sudo ln -s /Applications/Docker.app/Contents/Resources/bin/* $(brew --prefix)/bin/

