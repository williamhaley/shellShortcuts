RC_FILE=$$HOME/.bashrc

PI_RC=[[ -s "$$HOME/.bashrc_pi" ]] && . "$$HOME/.bashrc_pi"
WH_RC=[[ -s "$$HOME/.bashrc_will" ]] && . "$$HOME/.bashrc_will"

all: configs
	grep -q -F '$(WH_RC)' $(RC_FILE) || echo '$(WH_RC)' >> $(RC_FILE)

pi: all
	grep -q -F '$(PI_RC)' $(RC_FILE) || echo '$(PI_RC)' >> $(RC_FILE)

mac: all
	cp "Preferences.sublime-settings" "$$HOME/Library/Application Support/Sublime Text 2/Packages/User/Preferences.sublime-settings"

linux: all
	cp "Preferences.sublime-settings" "$$HOME/.config/sublime-text-3/Packages/User/"

configs:
	cp .bashrc_will $$HOME/
	cp .gitconfig $$HOME/
	cp .screenrc $$HOME/
	cp .vimrc $$HOME/

workssh:
	ln -sf ~/.ssh/id_rsa.orig ~/.ssh/id_rsa
	ln -sf ~/.ssh/id_rsa.orig.pub ~/.ssh/id_rsa.pub

personalssh:
	ln -sf ~/.ssh/id_rsa.williamhaley ~/.ssh/id_rsa
	ln -sf ~/.ssh/id_rsa.williamhaley.pub ~/.ssh/id_rsa.pub
