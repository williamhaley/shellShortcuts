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

# Recommended by direnv author to properly cd with direnv in shell scripts.
# https://github.com/direnv/direnv/issues/262
direnv_cd() {
	cd "$1"
	eval "$(direnv export bash)"
}

printfgreen()
{
	tput setaf 2
	printf "$@"
	tput sgr0
}

printfred()
{
	tput setaf 1
	printf "$@"
	tput sgr0
}

printfyellow()
{
	tput setaf 3
	printf "$@"
	tput sgr0
}

projectUpdate()
{
	for APP in `ls $1`;
		do (
			cd "$1/$APP"
			if [ -d ".git" ];
			then
				printf "${APP}: "
				printfgreen "[$(git currentbranch)] "
				git isdirty && printfred "dirty"
				git hasstash && printfyellow "stash"
				printf "\nbranches: $(git branch | wc -l | sed 's/^ *//;s/ *$//')\n"
				git submodule update --init --recursive
				git pull --rebase
				echo ""
			fi
		)
	done
}
