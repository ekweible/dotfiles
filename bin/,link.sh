#!/usr/bin/env bash

set -e

# Allows this script to be run from anywhere
cd "$(dirname "${BASH_SOURCE}")/.."
DOTFILES="$(pwd)"

# Source some utils
source ./lib_sh/echos.sh
source ./lib_sh/linkers.sh

# Link the shell config files
link_file $DOTFILES/shell/.bash_profile $HOME/.bash_profile
link_file $DOTFILES/shell/.bashrc $HOME/.bashrc
link_file $DOTFILES/shell/.profile $HOME/.profile
link_file $DOTFILES/shell/.sh_env $HOME/.sh_env
link_file $DOTFILES/shell/.zlogout $HOME/.zlogout
link_file $DOTFILES/shell/.zprofile $HOME/.zprofile
link_file $DOTFILES/shell/.zshenv $HOME/.zshenv
link_file $DOTFILES/shell/.zshrc $HOME/.zshrc
