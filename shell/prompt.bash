RESET='\[\e[1;0m\]'
RED_FG='\[\e[1;31m\]'
RED_BG='\[\e[1;41m\]'
GREEN_FG='\[\e[1;32m\]'
GREEN_BG='\[\e[1;42m\]'
BLUE_FG='\[\e[1;34m\]'
BLUE_BG='\[\e[1;44m\]'
CYAN_FG='\[\e[1;36m\]'
CYAN_BG='\[\e[1;46m\]'
WHITE_FG='\[\e[1;37m\]'
YELLOW_FG='\[\e[1;33m\]'
PURPLE_BG='\[\e[1;45m\]'
BOLD='\[\e[1;1m\]'

# You can *only* print the color from a sub-shell like this for PS1. Not the color
# *and* text. That causes issues with line length and so wrapping gets screwed up.
# It is possible to print text here, but you'd need to know the length in advance
# to properly add enough escape characters after the command in the PS1.
# PS1+="\[\$(color-for-profile)\]"
# http://stackoverflow.com/questions/6592077/bash-prompt-and-echoing-colors-inside-a-function
variable-color()
{
	if [[ true ]]; then
		printf "\033[1;31m"
	else
		printf "\033[1;32m"
	fi
}

source $CONFIGS_DIR/shell/git-prompt.sh

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_STATESEPARATOR=" "

system-emoji()
{
	EMOJIS=(🐶 ⚽️ 🏀 🏈 🎾 ⛵ 🐷 🐧 🍀 🌴 🌊)
	HOSTNAME_HASH=$(for c in $(grep -o . <<<`hostname`); do printf '%d' "'$c"; done)
	HOSTNAME_SHORT_HASH=$(printf ${HOSTNAME_HASH} | cut -b 1-5)

	NUM_FROM_HASH=$(printf $HOSTNAME_HASH | printf $((16#${HOSTNAME_SHORT_HASH})))
	LEN=${#EMOJIS[@]}

	INDEX=$(expr ${NUM_FROM_HASH} % ${LEN})
	printf ${EMOJIS[INDEX]}
}

# Prompt

# Not sure if there's any downside to this pattern. None seen so far.
# As a bonus, it also allows for easily setting conditionals since this
# is invoked before every command.
__prompt()
{
	PS1=""
	PS1+="${WHITE_FG}${BOLD}${BLUE_BG} \h ${CYAN_BG} \u `system-emoji` ${PURPLE_BG} \t ${GREEN_BG} \w ${RESET}"
	if git -C . rev-parse 2> /dev/null;
	then
		PS1+="${WHITE_FG}${BOLD}${RED_BG} $(__git_ps1 "%s") ${RESET}"
	fi
	PS1+="\n${RED_FG}$ ${RESET}"
}

function __versions()
{
	local str=""

	if type python | grep pyenv > /dev/null;
	then
		if hash python 2>/dev/null;
		then
			local v=$(python --version)

			if [ -n "${v}" ];
			then
				if [ -n "${str}" ];
				then
					str+=" | "
				fi

				str+="\n\001$(tput setaf 3)\002pyenv:\001$(tput sgr0)\002 ${v:7}"
			fi
		fi
	fi

	if hash go 2>/dev/null;
	then
		local v=$(go version)

		if [ -n "${v}" ];
		then
			if [ -n "{$str}" ];
			then
				str+=" | "
			fi

			str+="\001$(tput setaf 6)\002Golang:\001$(tput sgr0)\002 ${v:13:5}"
		fi
	fi

	if type node 2> /dev/null | grep nvm > /dev/null;
	then
		if hash node 2>/dev/null;
		then
			local v=$(node -v)
		fi

		if [ -n "${v}" ];
		then
			if [ -n "${str}" ];
			then
				str+=" | "
			fi
			str+="\001$(tput setaf 2)\002Node (nvm):\001$(tput sgr0)\002 ${v:1}"
		fi
	fi

	if type ruby | grep rvm > /dev/null;
	then
		local v=$(ruby -v)
		if [ -n "${str}" ];
		then
			str+=" | "
		fi
		str+="\001$(tput setaf 1)\002Ruby (rvm):\001$(tput sgr0)\002 ${v:5:8}\n"
	fi

	printf "${str}"
}

PS1="\n"
PS1+="${CYAN_FG}\u${RESET} on ${CYAN_FG}\h${RESET} at ${CYAN_FG}\w${RESET} ${GREEN_FG}"'$(__git_ps1 "[%s]")'"${RESET}"
PS1+='$(__versions)'
PS1+="\n"
PS1+="${RED_FG}\$"
PS1+="${RESET} "

# Runs after every command.
if shopt -q login_shell;
then
	PROMPT_COMMAND="echo"
else
	PROMPT_COMMAND="__prompt"
fi

