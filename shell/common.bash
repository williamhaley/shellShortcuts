# Set up workspace

mkdir -p $HOME/dev

# Specifically put *our* overrides before the
# standard system paths. This ensures we can
# (hopefully, when it makes sense) override
# executables from the system.
PATH=$CONFIGS_DIR/bin:$PATH
PATH=$HOME/bin:$PATH
PATH=$PATH:/opt/local/bin
PATH=$PATH:/opt/bin
PATH=$PATH:/opt/local/sbin
PATH=$HOME/.local/bin:$PATH
PATH=$PATH:/sbin
PATH=$HOME/.yarn/bin:$PATH

# RVM
PATH=$PATH:$HOME/.rvm/bin

# NVM
NVM_DIR=$HOME/.nvm

# PYENV
PATH=$HOME/.pyenv/shims:$PATH
PATH=$HOME/.pyenv/bin:$PATH
PYENV_ROOT=$HOME/.pyenv

# GOLANG
PATH=$HOME/dev/go/bin:$PATH
export GOPATH=$HOME/dev/go
if go -v >/dev/null 2>&1;
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

load-ruby()
{
	source $HOME/.rvm/scripts/rvm
}

load-node()
{
	(
		cd $HOME
		git clone https://github.com/creationix/nvm.git .nvm
		git checkout $(git describe --tags)
	)
	\. "$NVM_DIR/nvm.sh"
	\. "$NVM_DIR/bash_completion"

	nvm install stable
	nvm alias default stable
}

load-python()
{
	if [ ! -d "${PYENV_ROOT}" ];
	then
		git clone https://github.com/pyenv/pyenv.git "${PYENV_ROOT}"
	fi

	pyenv install 3.6.4 --skip-existing

	if command -v pyenv 1>/dev/null 2>&1;
	then
		eval "$(pyenv init -)"
	fi

	pyenv global 3.6.4
}

