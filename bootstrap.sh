#!/bin/sh
#
# bootstrap it!

export ZSH=/Users/evanweible/dev/config/dotfiles

set -e

# prompt for sudo credentials so we can use sudo when necessary in our scripts
sudo -v

# run through all the scripts
source $ZSH/scripts/includes.sh
source $ZSH/scripts/setup_gitconfig.sh
source $ZSH/scripts/install_dotfiles.sh
source $ZSH/scripts/install_node.sh
source $ZSH/scripts/install_pip.sh
source $ZSH/scripts/install_virtualenvwrapper.sh
source $ZSH/scripts/install_brew_dependencies.sh
source $ZSH/scripts/install_applications.sh
source $ZSH/scripts/setup_git_repos.sh
source $ZSH/scripts/change_shell_to_zsh.sh

success "bootstrap completed!"
