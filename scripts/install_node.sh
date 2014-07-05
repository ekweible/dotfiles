#!/bin/sh

source $ZSH/scripts/includes.sh

function install_node () {
    echo "node1"
    which node &>/dev/null
    echo "node2"
    if [ $? != 0 ]
    then
        error "NodeJS is not installed. Opening http://nodejs.org."
        sleep 3
        open "http://nodejs.org"
        info "Run bootstrap again when node is installed.\n"
        exit 1
    fi

    user '- do you want to setup node? (Y/n)'
    read -n 1 action
    br

    if [ "$action" == 'n' ]
    then
        return
    fi

    info 'setting permissions and installing default node dependencies...'
    run sudo chown -R `whoami` ~/.npm
    run sudo chown -R `whoami` /usr/local/lib/node_modules
    run npm install -g grunt-cli bower
    success "node setup"
}

echo "node0"

install_node

