#!/bin/sh
#
# bootstrap it!

export ZSH='/Users/evanweible/dev/config/dotfiles'

set -e

# prompt for sudo credentials so we can use sudo when necessary in our scripts
sudo -v

# run through all the scripts
source $ZSH/scripts/includes.sh
source $ZSH/git/setup_config.sh
source $ZSH/scripts/install_dotfiles.sh
source $ZSH/node/install.sh
source $ZSH/pip/install.sh
source $ZSH/pip/install_virtualenvwrapper.sh
source $ZSH/homebrew/install.sh
source $ZSH/ruby/install.sh
source $ZSH/applications/install.sh
source $ZSH/git/setup_repos.sh
source $ZSH/scripts/change_shell_to_zsh.sh

success "bootstrap completed!"
