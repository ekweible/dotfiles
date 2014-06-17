#!/bin/sh

source $ZSH/scripts/includes.sh

function install_applications () {
    user "- do you want to install your default suite of applications? (Y/n)"
    read -n 1 action
    br

    if [ "$action" == 'n' ]
    then
        return
    fi

    info "opening application download URLs"
    python2.7 py/install_apps.py
    wait
    success "application download URLs opened"
}

install_applications