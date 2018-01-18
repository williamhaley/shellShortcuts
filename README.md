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
```

Disable the `whitespace` package so that it does not conflict with `editorconfig`.

## vim

```
vim
:PlugInstall
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

