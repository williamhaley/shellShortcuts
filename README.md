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

In iTerm go to Preferences and use the "Load preferences from a custom folder or URL:" to specify the `iTermSettings` folder where settings are stored. Do *not* copy local settings when prompted. Instead, we'll override them with what's in the `iTermSettings` folder.

## Atom

```
apm install \
	joefitzgerald/gofmt \
	joefitzgerald/go-get \
	joefitzgerald/go-config \
	editorconfig
```

Disable the `whitespace` package so that it does not conflict with `editorconfig`.

## vim

```
vim
:PlugInstall
```

## Backups

```
rclone config
```

Create a new `b2` remote named `Backup`. The keys are in the B2 Web UI.

```
# Backup files to cloud
cloud-backup
```

Create a new `b2` remote named `Crypt`. It is an encrypted remote off of `Backup`.

I recommend using a separate `b2` bucket in this case. So I would create a bucket like `backup-crypt`. In the `rclone config` menu I would choose `5` to encrypt another remote

Remember that `Backup` is the name of the unencrypted remote.

Put `Backup:encrypted-bucket` for the remote definition entry. Choose `standard` encryption for the naming.

Define variables for backups in `$CONFIGS_DIR/ENV`.

