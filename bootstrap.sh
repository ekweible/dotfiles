#!/bin/sh
#
# bootstrap it!

set -e

# prompt for sudo credentials so we can use sudo when necessary in our scripts
sudo -v

# run through all the scripts
source scripts/includes.sh
source scripts/setup_gitconfig.sh
source scripts/install_dotfiles.sh
source scripts/install_node.sh
source scripts/install_pip.sh
source scripts/install_virtualenvwrapper.sh
source scripts/install_brew_dependencies.sh
source scripts/install_applications.sh
source scripts/setup_git_repos.sh
source scripts/change_shell_to_zsh.sh

success "bootstrap completed!"
