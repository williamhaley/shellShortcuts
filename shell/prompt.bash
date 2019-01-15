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

PS1="\n"
PS1+="${CYAN_FG}\u${RESET} on ${CYAN_FG}\h${RESET} at ${CYAN_FG}\w${RESET} ${GREEN_FG}"'$(__git_ps1 "[%s] ")'"${RESET}"
PS1+="${RED_FG}\$"
PS1+="${RESET} "

