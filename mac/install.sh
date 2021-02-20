#!/usr/bin/env bash

if ! [ -d "/Applications/Xcode.app" ];
then
    echo "install xcode via the store"
    exit 1
fi

xcode-select --install

brew install \
    ack \
    awscli \
    qemu \
    ffmpeg \
    gimp \
    git-lfs \
    jq \
    keepassxc \
    tmux \
    rsync \
    golang \
    visual-studio-code \
    vlc

