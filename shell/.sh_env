#!/usr/env/bin sh
# Sourced by every shell (whether interactive or not) via ~/.zprofile or ~/.bash_profile
# Should be compatible with any shell.

export DOTFILES=$HOME/.config/dotfiles
export DOTFILES_PRIVATE=$HOME/.config/dotfiles_private
export DOTFILES_PROFILE=$HOME/.config/dotfiles_profile
export PATH=$PATH:$DOTFILES/bin
export PATH=$PATH:$DOTFILES_PRIVATE/bin
export PATH=$PATH:$DOTFILES_PROFILE/bin

# Private/proprietary shell profile (not to be checked into the public repo) :)
[ -f $DOTFILES_PRIVATE/.profile ] && source $DOTFILES_PRIVATE/.profile
[ -f $DOTFILES_PROFILE/.profile ] && source $DOTFILES_PROFILE/.profile
