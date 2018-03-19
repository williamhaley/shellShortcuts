RESET='\[\e[1;0m\]'
CYAN_COLOR='\[\e[1;36m\]'
RED_COLOR='\[\e[1;31m\]'
GREEN_COLOR='\[\e[1;32m\]'
GRAY_COLOR='\[\e[1;30m\]'
YELLOW_COLOR='\[\e[1;33m\]'
BLUE_COLOR='\[\e[1;34m\]'

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
	HOSTNAME_SHORT_HASH=$(echo ${HOSTNAME_HASH} | cut -b 1-5)

	NUM_FROM_HASH=$(echo $HOSTNAME_HASH | echo $((16#${HOSTNAME_SHORT_HASH})))
	LEN=${#EMOJIS[@]}

	INDEX=$(expr ${NUM_FROM_HASH} % ${LEN})
	printf ${EMOJIS[INDEX]}
}

PS1=""

# Hostname and current dir.
PS1+="${CYAN_COLOR}\h:${BLUE_COLOR}\w"

# Username.
PS1+=" ${GREEN_COLOR}(\u|`system-emoji`)"

# Change color.
PS1+=" ${YELLOW_COLOR}"

# Git.
PS1+='$(__git_ps1 "[%s]")'

# Detect SSH

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
	session_type=remote/ssh
# many other tests omitted
else
	case $(ps -o comm= -p $PPID) in
		sshd|*/sshd) session_type=remote/ssh;;
	esac
fi

if [ "${session_type}" = "remote/ssh" ];
then
	PS1+=" ~~ SSH ~~"
fi

# New line.
PS1+="\n"

# Prompt.
PS1+="${RED_COLOR}\$"

# Reset colors for input.
PS1+="${RESET} "

PROMPT_COMMAND="echo"
