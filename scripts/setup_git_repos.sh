#!/bin/sh

source $ZSH/scripts/includes.sh

setup_git_repos () {
    user "- do you want to setup your git repositories? (Y/n)"
    read -n 1 action
    br
    if [ "$action" == 'n' ]
    then
        return
    fi

    python2.7 py/setup_git_repos.py

    if [ "$?" != 0 ]
    then
        exit
    fi

    success "git repositories setup"
}

setup_git_repos