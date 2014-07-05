#!/bin/sh

source $ZSH/scripts/includes.sh

function install_node () {
    if test ! $(which node)
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
    if [ ! -d "$HOME/.npm" ]; then
	mkdir ~/.npm
    fi
    run sudo chown -R `whoami` ~/.npm

    if [ ! -d "/usr/local/lib/node_modules" ]; then
    	mkdir /usr/local/lib/node_modules
    fi
    run sudo chown -R `whoami` /usr/local/lib/node_modules
    
    run sudo npm install -g grunt-cli bower
    success "node setup"
}

install_node

