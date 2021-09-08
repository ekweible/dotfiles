#!/usr/bin/env bash

# Allows this script to be run from anywhere
cd "$(dirname "${BASH_SOURCE}")/.."

# Source some utils
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

# Install dependencies and apps using brew bundle
running "brew bundle -v --file Brewfile"
brew bundle -v --file Brewfile

# If the private profile includes a Brewfile, install it, too.
if [ -f ./private/Brewfile ]; then
    running "brew bundle -v --file private/Brewfile"
    brew bundle -v --file private/Brewfile
fi

ok
