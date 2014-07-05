#!/bin/sh

source $ZSH/scripts/includes.sh

function install_virtualenvwrapper () {
    if [ ! -f /usr/local/bin/virtualenvwrapper.sh ]
    then
        sudo -v
        info "installing virtualenvwrapper..."
        run sudo -A pip install virtualenvwrapper
        success "virtualenvwrapper installed"
    fi
}

install_virtualenvwrapper