Dotfiles
---

> Dotfiles repo created by Evan Weible, modeled after [Zach Holman's dotfiles repo](https://github.com/holman/dotfiles).
> Provides a bootstrap script for a super quick setup time.

## Quick Setup

1. Generate an SSH key (https://help.github.com/articles/generating-ssh-keys):
  - `mkdir ~/.ssh/ekweible/`
  - `ssh-keygen -t rsa -C "[email]"`, enter the directory created above
  - create a passphrase & write it down
  - `ssh-add ~/.ssh/ekweible/id_rsa`
  - `pbcopy < ~/.ssh/ekweible/id_rsa.pub`
  - GitHub > Account Settings > SSH Keys > Add SSH Key
  - Test it out: `ssh -T git@github.com`
1. Create a dev directory and a directory specifically for config related dev
  - `mkdir ~/dev && mkdir ~/dev/config && mkdir ~/dev/config`
1. Run `git` and when prompted, click "install" to install the command line developer tools
1. Install this dotfiles repo:
  - `cd ~/dev/config`
  - `git clone git@github.com:ekweible/dotfiles.git`
1. Run the bootstrap script:
  - `cd ~/dev/config/dotfiles`
  - `sh bootstrap.sh`


## Topical

Everything's built around topic areas. If you're adding a new area to your forked dotfiles — say, "Java" — you can
simply add a java directory and put files in there. Anything with an extension of .zsh will get automatically included
into your shell. Anything with an extension of .symlink will get symlinked without extension into $HOME, and anything
with an extension of .dirsymlink will be symlinked without extension into $HOME/parent/, where parent is the name of
the parent directory. For example:

```
$HOME/.gitignore --> git/gitignore.symlink
$HOME/.pip/pip.conf --> pip/pip.conf.dirsymlink
```


## Bootstrap

Run `sh bootstrap.sh` from your dotfiles repository.

__This is safe to run multiple times, it will not overwrite anything that is already in place__.

The bootstrap script runs through a series of steps that setup and configure different parts of your computer, each of
which is optional and can be skipped.

1. If `git/gitconfig.symlink` is not found, you will be prompted for a username and email and one will be created using
[`git/gitconfig.symlink.example` as a template.
1. If NodeJS is not installed, the NodeJS download page will be opened and you will be asked to rerun the script after
installing it.
1. Dotfiles will be symlinked to your home directory (every .symlink or .dirsymlink file).
1. If pip is missing, it will be installed.
1. If virtualenvwrapper is missing, it will be installed.
1. Brew will be updated, some default dependencies will be installed, and all dependencies will be upgraded.
1. All applications listed in conf/applications.json will be opened in your browser for you to download.
1. Your git repositories will be setup using the conf/gitWorkspaces.json file as a map. You can specify
workspaces that contain any number of repos, each of which contain an origin, an upstream, and a set of remotes.
1. Your default shell will be changed to zsh.
