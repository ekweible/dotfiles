#!/usr/bin/env bash

# Allows this script to be run from anywhere
cd "$(dirname "${BASH_SOURCE}")/.."
DOTFILES="$(pwd)"
DOTFILES_PRIVATE="$DOTFILES/../dotfiles_private"
DOTFILES_PROFILE="$DOTFILES/../dotfiles_profile"

# Source some utils
source ./lib_sh/brew.sh
source ./lib_sh/echos.sh
source ./lib_sh/linkers.sh

# Homebrew
brew_bin=$(which brew) 2>&1 > /dev/null
if [[ $? != 0 ]]
then
    running "installing homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if [[ $? != 0 ]]
    then
        error "unable to install homebrew, script $0 abort!"
        exit 2
    fi

    ok "done"
else
    ok "homebrew already installed"
fi

setup_brew_env_if_missing

function brew_bundle() {
    repo="$(basename $(pwd))"
    if [ -f Brewfile ]
    then
        running "[$repo] brew bundle -v --file Brewfile $@"
        brew bundle -v --file Brewfile $@
    fi
}

# Step 1: brew bundle from the main dotfiles repo
brew_bundle

# Step 2: brew bundle from the private dotfiles repo
cd $DOTFILES_PRIVATE
brew_bundle

# Step 3: brew bundle from the profile-specific dotfiles repo
cd $DOTFILES_PROFILE
brew_bundle

ok
