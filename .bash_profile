#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

PATH=$PATH:/build/node/bin:~/bin/mongo

alias ls="ls --color"
alias toupper="tr '[:lower:]' '[:upper:]'"
alias tolower="tr '[:upper:]' '[:lower:']"
alias alphahash='hash=$(cat /dev/urandom | LC_CTYPE=C tr -dc A-Za-z0-9 | head -c 64) && echo $hash'

alias clearcache='(cd /apps/chef/scripts/; vagrant ssh -c "rm -rf /apps/*/_smarty/templates_c/*; rm -rf /apps/cachebuster-folder*; sudo rm -rf /export/cache/nginx/*; mkdir /apps/cachebuster-folder-$RANDOM")'
alias stack='(cd /apps/chef/scripts/; vagrant ssh -c "service nginx restart";)'

#templates_c is a Smarty template gen dir
alias wsgrep='grep --color --exclude-dir=".git" --exclude-dir="templates_c" "$@"'

alias gitgrep='git grep "$@" $(git rev-list --all)'
alias gitdiff='git stash show -p stash@{0}'
