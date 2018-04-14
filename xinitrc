#!/bin/sh

xbindkeys -p &
tint2 &

# Dual monitor setup. [DVI][VGA]
xrandr \
	--output DVI-D-0 --auto --primary \
	--output VGA-0 --auto --right-of DVI-D-0 &

xscreensaver -no-splash &
exec openbox-session

