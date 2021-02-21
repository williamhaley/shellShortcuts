#!/usr/bin/env bash

if ! [ -d "/Applications/Xcode.app" ];
then
    echo "install xcode via the store"
    exit 1
fi

xcode-select --install

brew install \
    ack \
    alacritty \
    awscli \
    caffeine \
    dropbox \
    ffmpeg \
    gimp \
    git-lfs \
    golang \
    jq \
    keepassxc \
    qemu \
    rsync \
    spotify \
    tmux \
    visual-studio-code \
    vlc

