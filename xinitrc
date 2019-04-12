#!/bin/sh

if command -v dropbox > /dev/null;
then
	dropbox &
fi

xmodmap ~/.Xmodmap
xbindkeys -p &
tint2 &

# Dual monitor setup. I typically have one VGA and one DVI
# Run xrandr (no args) to see monitor ids. They may change!
dvi=$(xrandr | grep -i dvi | awk '{print $1}')
vga=$(xrandr | grep -i vga | awk '{print $1}')
# Arrangement is typically: [VGA][DVI]
xrandr \
	--output ${dvi} --auto --primary \
	--output ${vga} --auto --left-of ${dvi} &

numlockx &

eval $(ssh-agent)

xscreensaver -no-splash &
exec openbox-session
