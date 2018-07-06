#!/bin/sh

if command -v dropbox > /dev/null;
then
	dropbox &
fi

xbindkeys -p &
tint2 &

# Dual monitor setup. [DVI][VGA]
xrandr \
	--output DVI-D-0 --auto --primary \
	--output VGA-0 --auto --right-of DVI-D-0 &

numlockx &

eval $(ssh-agent)

xscreensaver -no-splash &
exec openbox-session

