# Use this file to install/setup my configs

RC_FILE=$$HOME/.bashrc

PI_RC=[[ -s "$$HOME/.bashrc_pi" ]] && . "$$HOME/.bashrc_pi"
WH_RC=[[ -s "$$HOME/.bashrc_will" ]] && . "$$HOME/.bashrc_will"

all: configs
        grep -q -F '$(WH_RC)' $(RC) || echo '$(WH_RC)' >> $(RC_FILE)

pi: all
        grep -q -F '$(PI_RC)' $(RC) || echo '$(PI_RC)' >> $(RC_FILE)

mac: all
        cp "Preferences.sublime-settings" "$$HOME/Library/Application Support/Sublime Text 2/Packages/User/Preferences.sublime-settings"

configs:
        cp .bashrc_will $$HOME/
        cp .gitconfig $$HOME/
        cp .screenrc $$HOME/
        cp .vimrc $$HOME/
