# Set up workspace

mkdir -p $HOME/dev

PATH=$CONFIGS_DIR/bin:$PATH
PATH=$HOME/bin:$PATH
PATH=/opt/local/bin:$PATH
PATH=/opt/bin:$PATH:
PATH=/opt/local/sbin:$PATH
PATH=$HOME/.local/bin:$PATH
PATH=/sbin:$PATH
PATH=$HOME/.yarn/bin:$PATH

# RVM
# See alias below to load RVM in the shell.
PATH=$PATH:$HOME/.rvm/bin

# NVM
NVM_DIR=$HOME/.nvm

# PYENV - https://github.com/pyenv/pyenv
# Still must install pyenv and switch
# versions using `pyenv local` or configs.
PATH=$HOME/.pyenv/shims:$PATH
PYENV_ROOT=$HOME/.pyenv

export GOPATH=$HOME/dev/go
if ! go -v >/dev/null 2>&1;
then
	export PATH=$PATH:$(go env GOPATH)/bin
fi

# Mac vs Linux

# Could also wrap this up into a function if that makes more sense.
if [ "$(uname)" != "Darwin" ]; then
	. $CONFIGS_DIR/shell/linux.bash
else
	. $CONFIGS_DIR/shell/mac.bash
fi

# Functions

# This *must* be a function. It cannot be in a script.
# Recommended by direnv author to properly cd with direnv in shell scripts.
# https://github.com/direnv/direnv/issues/262
direnv_cd() {
	cd "$1"
	eval "$(direnv export bash)"
}

load-rvm()
{
	source $HOME/.rvm/scripts/rvm
}

load-nvm()
{
	\. "$NVM_DIR/nvm.sh"
	\. "$NVM_DIR/bash_completion"
}

