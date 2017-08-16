alias jack_output='sudo modprobe snd_bcm2835 && amixer cset numid=3 1'
alias hdmi_output='sudo modprobe snd_bcm2835 && amixer cset numid=3 0'
alias video='mplayer -nolirc -vo fbdev2:/dev/fb0 $@'
