# Set up Workspace

mkdir -p $HOME/Workspace

# Variables

PATH=$CONFIGS_DIR/bin:$HOME/bin:$PATH:$HOME/.local/bin:/sbin

export GOPATH=$HOME/Workspace/go
if [ go version &> /dev/null ];
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
function direnv_cd() {
	cd "$1"
	eval "$(direnv export bash)"
}

function printfgreen()
{
	tput setaf 2
	printf "$@"
	tput sgr0
}

function printfred()
{
	tput setaf 1
	printf "$@"
	tput sgr0
}

function printfyellow()
{
	tput setaf 3
	printf "$@"
	tput sgr0
}

function projectUpdate()
{
	for APP in `ls $1`;
		do (
			cd "$1/$APP"
			printf "${APP}: "
			printfgreen "[$(git currentbranch)] "
			git isdirty && printfred "dirty"
			git hasstash && printfyellow "stash"
			printf "\nbranches: $(git branch | wc -l | sed 's/^ *//;s/ *$//')\n"
			git submodule update --init --recursive
			git pull
		)
		echo ""
	done
}

