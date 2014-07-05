#!/bin/sh

source $ZSH/scripts/includes.sh

function install_pip () {
    if test ! $(which pip); then
        sudo -v
        info "downloading and installing pip..."
        run curl -O https://bootstrap.pypa.io/get-pip.py
        run sudo python2.7 get-pip.py
	run rm get-pip.py
        success "pip installed"
    fi
}

install_pip
