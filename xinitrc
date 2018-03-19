#!/bin/sh

xbindkeys -p &
tint2 &
xrandr --output DVI-D-0 --auto --primary --left-of VGA-0 &
xrandr --output VGA-0 --auto &
xscreensaver -no-splash &
exec openbox-session
