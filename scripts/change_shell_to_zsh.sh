#!/bin/sh

source $ZSH/scripts/includes.sh

function change_shell_to_zsh () {
    # skip this if zsh is already current shell
    if ! [ -n "$ZSH_NAME" ]
    then
        return
    fi

    user '- do you want to change the shell to zsh? (Y/n)'
    read -n 1 action
    br

    if [ "$action" == 'n' ]
    then
        return
    fi

    info "setting shell to zsh"
    chsh -s $(which zsh)
    success "shell changed to zsh - will have to logout and log back in"
}

change_shell_to_zsh