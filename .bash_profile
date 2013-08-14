#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

alias toupper="tr '[:lower:]' '[:upper:]'"
alias tolower="tr '[:upper:]' '[:lower:']"
alias alphahash='hash=$(cat /dev/urandom | LC_CTYPE=C tr -dc A-Za-z0-9 | head -c 64) && echo $hash'

#workspace grep (search)
function wsgrep() 
{
	#templates_c is a Smarty template gen dir
	grep "$@" | grep -iv "\.svn/*" | grep -v "\.git/*" | grep -v "templates_c/*"
}

