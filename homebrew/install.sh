#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.
#
# Note: Homebrew now expects the ENTER key to confirm installation

source $ZSH/scripts/includes.sh

function install_brew () {
    if test ! $(which brew); then
        info "installing homebrew\n"
        ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
	success "brew installed"
    fi

    user "- do you want to install brew dependencies (Y/n)"
    read -n 1 action
    br

    if [ "$action" == 'n' ]; then
        return
    fi

    # Install homebrew packages
    run brew install grc coreutils bash-completion ant
    success "brew dependencies installed"
}

install_brew
