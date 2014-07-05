#!/bin/sh

source $ZSH/scripts/includes.sh

update_git_master () {
    user "- do you want update your origin's master with upstream? (Y/n)"
    read -n 1 action
    br
    if [ "$action" == 'n' ]
    then
        return
    fi

    git checkout upstream && git pull && git checkout master && git merge upstream && git push origin master

    if [ "$?" != 0 ]
    then
        fail "master could not be updated with upstream"
    fi

    success "master updated with upstream"
}

update_git_master