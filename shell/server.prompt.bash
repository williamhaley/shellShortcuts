RESET='\[\e[1;0m\]'
CYAN_COLOR='\[\e[1;36m\]'
RED_COLOR='\[\e[1;31m\]'
GREEN_COLOR='\[\e[1;32m\]'
GRAY_COLOR='\[\e[1;30m\]'
YELLOW_COLOR='\[\e[1;33m\]'
BLUE_COLOR='\[\e[1;34m\]'

source $CONFIGS_DIR/shell/git-prompt.sh

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_STATESEPARATOR=" "

PS1=""

# Hostname and current dir.
PS1+="${RED_COLOR}\h:\w"

# Username.
PS1+=" (\u)"

# Change color.
PS1+=" ${BLUE_COLOR}"

# Git.
PS1+='$(__git_ps1 "[%s]")'

# New line.
PS1+="\n"

# Prompt.
PS1+="\$"

# Reset colors for input.
PS1+="${RESET} "

PROMPT_COMMAND="echo"
