# Overview

This repo contains my config files, aliases, bash helpers, etc.

Various application config files can be copied manually as needed.

# Install

Clone the repo to `$HOME` using the SSH clone URL.

Add this to `.bashrc` or whatever shell config is appropriate.

```
export CONFIGS_DIR=$HOME/configs
source $CONFIGS_DIR/shell/shellrc
```

Close and re-open the terminal so that those changes take effect.

On a Mac, you may need to create a `.profile` file that looks like this.

```
source $HOME/.bashrc
```

Set up dotfiles, configs, etc.

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
code --install-extension \
	EditorConfig.editorconfig
code --install-extension \
	felixrieseberg.vsc-ember-cli EditorConfig.editorconfig
code --install-extension \
	PeterJausovec.vscode-docker
code --install-extension \
	lukehoban.Go
code --install-extension \
	Rubymaniac.vscode-direnv

# Dependencies for Go extension
go get -v github.com/rogpeppe/godef
go get -v github.com/uudashr/gopkgs/cmd/gopkgs
go get -v github.com/nsf/gocode
go get -v sourcegraph.com/sqs/goreturns
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
sudo archive
```

Use with caution!

```
restore
```

