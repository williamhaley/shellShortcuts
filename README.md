# Overview

This repo contains my config files, aliases, bash helpers, etc.

Various application config files can be copied manually as needed.

# Install

Clone the repo to `$HOME` using the SSH clone URL.

```
cat <<'EOF' >~/.bash_profile
#
# ~/.bash_profile
#
# Loaded only for login bash sessions (new TTY/SSH).

[[ -f ~/.bashrc ]] && . ~/.bashrc
EOF
```

Load my common shell configuration file.

```
cat <<'EOF' >~/.bashrc
#
# ~/.bashrc
#
# Loaded for non-login bash sessions (new tab) and sourced by bash_profile.

export CONFIGS_DIR=$HOME/configs
source $CONFIGS_DIR/shell/bashrc
EOF
```

Close and re-open the terminal so that those changes take effect.

Run this to set up aliases, symlinks, copy config files into place, etc.

```
willconfig
```

# Specific config instructions

## iTerm

[Run these](http://stratus3d.com/blog/2015/02/28/sync-iterm2-profile-with-dotfiles-repository/) then close and reopen iTerm.

```
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "$HOME/configs/iTermSettings"
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
```

## VSCode

```
code \
	--install-extension streetsidesoftware.code-spell-checker \
	--install-extension EditorConfig.EditorConfig \
	--install-extension lukehoban.Go \
	--install-extension CoenraadS.bracket-pair-colorizer \
	--install-extension oderwat.indent-rainbow
```

The `direnv` command should pick up `GOPATH` if using `.envrc` files. Use the command palette -> `Go: Current GOPATH` to verify. Direnv assumes there's a single `.envrc` in your root workspace.

## vim

Vim 8 plugins.

```
# Fuzzy Find
git clone https://github.com/ctrlpvim/ctrlp.vim ~/.vim/pack/plugins/start/ctrlp

# Go
git clone https://github.com/fatih/vim-go.git ~/.vim/pack/plugins/start/vim-go

# Autocomplete
git clone https://github.com/Valloric/YouCompleteMe ~/.vim/pack/plugins/start/youcompleteme
# Make sure all build tools are installed (cmake, etc).
# https://github.com/Valloric/YouCompleteMe#installation
(
	cd ~/.vim/pack/plugins/start/youcompleteme &&
	git submodule update --init --recursive &&
	./install.py --go-completer
)
```

## Backups

```
sudo backup
```

