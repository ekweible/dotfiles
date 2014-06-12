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