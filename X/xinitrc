#!/bin/sh

if command -v dropbox > /dev/null;
then
	dropbox &
fi

xmodmap ~/.Xmodmap
xbindkeys -p &

# Dual monitor setup. I typically have one VGA and one DVI
# Run xrandr (no args) to see monitor ids. They may change!
dvi=$(xrandr | grep -i "hdmi\|dvi" | grep -i " connected " | awk '{print $1}')
vga=$(xrandr | grep -i vga | grep -i " connected " | awk '{print $1}')
# Arrangement is typically: [VGA][DVI]
xrandr \
	--output ${dvi} --auto --primary \
	--output ${vga} --auto --left-of ${dvi} &

tint2 &

numlockx &

eval $(ssh-agent)

xscreensaver -no-splash &

xrdb ~/.Xresources

exec openbox-session
