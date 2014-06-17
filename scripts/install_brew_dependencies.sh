#!/bin/sh

source $ZSH/scripts/includes.sh

function install_brew_dependencies () {
    user "- do you want to install and upgrade brew dependencies? (Y/n)"
    read -n 1 action
    br

    if [ "$action" == 'n' ]
    then
        return
    fi

    # If we're on a Mac, let's install and setup homebrew.
    if [ "$(uname -s)" == "Darwin" ]
    then
      info "installing brew dependencies"
      if source bin/dot > /tmp/dotfiles-dot 2>&1 && sh homebrew/install.sh > /tmp/dotfiles-brew-install 2>&1
      then
        success "dependencies installed"
      else
        fail "error installing dependencies"
      fi
    fi
}

install_brew_dependencies