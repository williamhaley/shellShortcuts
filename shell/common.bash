# Append system paths to end of $PATH
PATH=$PATH:/opt/bin:/opt/local/bin:/opt/local/sbin:/sbin:/usr/local/bin

# Prepend user paths to start of $PATH
PATH=$HOME/bin:$HOME/.local/bin:$HOME/.yarn/bin:$CONFIGS_DIR/bin:$PATH

# RVM
PATH=$PATH:$HOME/.rvm/bin

# NVM
NVM_DIR=$HOME/.nvm

# PYENV
PATH=$HOME/.pyenv/shims:$HOME/.pyenv/bin:$PATH
PYENV_ROOT=$HOME/.pyenv

# GOLANG
PATH=$HOME/dev/go/bin:$PATH
export GOPATH=$HOME/dev/go
if go -v >/dev/null 2>&1;
then
	export PATH=$PATH:$(go env GOPATH)/bin
fi

# Could also wrap this up into a function if that makes more sense.
if [ "$(uname)" != "Darwin" ]; then
	case "$TERM" in
		screen*) PROMPT_COMMAND='echo -ne "\033k\033\0134"'
	esac

	alias linux-set-time='sudo /usr/sbin/ntpdate pool.ntp.org && sudo hwclock --systohc'
	alias tree="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'"
	# alias battery="upower -i $(upower -e | grep BAT) | grep --color=never -E percentage|xargs|cut -d' ' -f2|sed s/%//"

	complete -cf sudo

	export IS_LINUX=true
else
	# Enable colors.
	export CLICOLOR=1
	# Light background.
	#export LSCOLORS=ExFxCxDxBxegedabagacad
	# Dark background.
	export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

	export IS_MAC=true
fi

# Functions

# This *must* be a function. It cannot be in a script.
# Recommended by direnv author to properly cd with direnv in shell scripts.
# https://github.com/direnv/direnv/issues/262
direnv_cd() {
	cd "$1"
	eval "$(direnv export bash)"
}

