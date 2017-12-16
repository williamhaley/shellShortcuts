# If not running interactively, don't do anything
[[ $- != *i* ]] && return

case "$TERM" in
    screen*) PROMPT_COMMAND='echo -ne "\033k\033\0134"'
esac

alias ls='ls --color=auto'
alias linux-set-time='sudo /usr/sbin/ntpdate pool.ntp.org && sudo hwclock --systohc'
alias tree="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'"
alias ripcd='abcde -o mp3 -q high'
# alias battery="upower -i $(upower -e | grep BAT) | grep --color=never -E percentage|xargs|cut -d' ' -f2|sed s/%//"
alias rm='rm --interactive=once'

complete -cf sudo

export IS_LINUX=true

