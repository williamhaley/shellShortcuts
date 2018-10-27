# Overview

This repo contains my config files, aliases, bash helpers, etc.

Various application config files can be copied manually as needed.

# Install

Clone the repo to `$HOME` using the SSH clone URL. Clobber `.bash_profile` with this.

```
#
# ~/.bash_profile
#
# Loaded only for login bash sessions (new TTY/SSH).

[[ -f ~/.bashrc ]] && . ~/.bashrc
```

Append this to `.bashrc`.

```
#
# ~/.bashrc
#
# Loaded for non-login bash sessions (new tab) and sourced by bash_profile.

export CONFIGS_DIR=$HOME/configs
source $CONFIGS_DIR/shell/bashrc
```

Close and re-open the terminal so that those changes take effect.

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
	--install-extension eg2.tslint \
	--install-extension vsmobile.vscode-react-native
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

