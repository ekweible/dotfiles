#!/usr/env/bin sh
# Sourced by every shell (whether interactive or not) via ~/.zprofile or ~/.bash_profile
# Should be compatible with any shell.

export DEV=$HOME/dev
export DOTFILES=$HOME/.config/dotfiles
export PATH=$PATH:$DOTFILES/bin
export PATH=$PATH:$DOTFILES/private/bin

# Private/proprietary shell profile (not to be checked into the public repo) :)
[ -f $DOTFILES/private/.profile ] && source $DOTFILES/private/.profile
