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
	tmux \
	rsync \
	golang

brew cask install \
	caffeine \
	firefox \
	gimp \
	google-chrome \
	google-drive \
	slack \
	vagrant \
	virtualbox \
	visual-studio-code \
	vlc

# Install the App, not just binaries.
brew cask install docker
sudo ln -s /Applications/Docker.app/Contents/Resources/bin/* $(brew --prefix)/bin/

