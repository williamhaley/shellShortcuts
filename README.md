# Overview

This repo contains my config files, aliases, zsh/bash/shell helpers, etc.

Various application config files can be copied manually as needed.

# Install

Clone the repo to `$HOME` using the SSH clone URL.

Clobber `.zshrc` with this (replace zsh with bash where needed). On macOS for bash use `.bash_profile`.

```
#
# ~/.zshrc
#

export CONFIGS_DIR=$HOME/configs
source $CONFIGS_DIR/zsh/zshrc
```

Run this to set up aliases, symlinks, copy config files into place, etc.

```
willconfig
```

Create a `.gitconfig.work` if you want to override standard `.gitconfig` with settings on this machine.

# Specific config instructions

## VSCode

```
code \
	--install-extension streetsidesoftware.code-spell-checker \
	--install-extension EditorConfig.EditorConfig \
	--install-extension ms-vscode.Go \
	--install-extension CoenraadS.bracket-pair-colorizer \
	--install-extension oderwat.indent-rainbow \
	--install-extension dbaeumer.vscode-eslint \
	--install-extension editorconfig.editorconfig \
	--install-extension esbenp.prettier-vscode
```

The `direnv` command should pick up `GOPATH` if using `.envrc` files. Use the command palette -> `Go: Current GOPATH` to verify. Direnv assumes there's a single `.envrc` in your root workspace.

## vim

Vim 8 plugins.

```
# EditorConfig
git clone https://github.com/editorconfig/editorconfig-vim ~/.vim/pack/plugins/start/editorconfig-vim

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

