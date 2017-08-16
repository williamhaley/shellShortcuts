# Variables

PATH=$CONFIGS_DIR/bin:$HOME/bin:$PATH:$HOME/.local/bin:/sbin

# Mac vs Linux

# Could also wrap this up into a function if that makes more sense.
if [ "$(uname)" != "Darwin" ]; then
	. $CONFIGS_DIR/shell/linux.bash
else
	. $CONFIGS_DIR/shell/mac.bash
fi

# Aliases

alias wsgrep='grep --color --exclude-dir=".git" --exclude-dir="*node_modules*" --exclude-dir="*public/assets/d*" --exclude-dir="*public/assets/p*" --exclude-dir="templates_c" "$@"'
alias dockerclean='CONTAINERS=$(docker ps -a --format "{{.ID}}"); for C in "$CONTAINERS"; do docker rm $C; done; IMAGES=$(docker images --format "{{.ID}}"); for I in "$IMAGES"; do docker rmi $I; done;'

# Functions

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
