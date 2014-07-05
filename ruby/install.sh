#!/bin/sh

source $ZSH/scripts/includes.sh

setup_ruby () {
    if test ! $(which rbenv); then
        info "installing rbenv..."
        run brew install rbenv
        success "rbenv installed."
    fi
}

setup_ruby
