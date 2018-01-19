# Set up workspace

mkdir -p $HOME/dev

# Variables

PATH=$CONFIGS_DIR/bin:$HOME/bin:/opt/local/bin:/opt/bin:$PATH:$HOME/.local/bin:/sbin

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

