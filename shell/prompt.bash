RESET='\[\e[1;0m\]'
RED_FG='\[\e[1;31m\]'
GREEN_FG='\[\e[1;32m\]'
BLUE_FG='\[\e[1;34m\]'
CYAN_FG='\[\e[1;36m\]'
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

PS1=""
PS1+="${CYAN_FG}\u${RESET} at ${CYAN_FG}\w${RESET} (${BLUE_FG}\t${RESET})"
PS1+=" ${GREEN_FG}"'$(__git_ps1 "%s")'"${RESET}\n"
PS1+="${RED_FG}\$"
PS1+="${RESET} "

