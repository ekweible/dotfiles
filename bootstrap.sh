#!/bin/sh

DOTFILES_ROOT="`pwd`"

set -e

br () {
  printf "\n"
}

info () {
  printf "[\033[00;34m..\033[0m] $1"
}

user () {
    printf "\r[\033[0;33m?\033[0m] $1 "
}

success () {
    printf "\r\033[2K[\033[00;32mOK\033[0m] $1\n"
}

error () {
    printf "\r\033[2K[\033[00;31mERR\033[0m] $1\n"
}

fail () {
    printf "\r\033[2K[\033[0;31mFAIL\033[0m] $1\n"
    echo ''
    exit
}

run () {
    "$@" 2> "_stderr.txt" 1> "_stdout.txt"
}

wait_to_continue () {
    wait &&  read -p "Press any key to continue... \n" -n1 -s
}

install_node () {
    which node &>/dev/null
    if [ $? != 0 ]
    then
        error "NodeJS is not installed. Opening http://nodejs.org."
        sleep 3
        open "http://nodejs.org"
        info "Run bootstrap again when node is installed.\n"
        exit 1
    fi

    run npm install
    run sudo chown -R `whoami` ~/.npm
    run sudo chown -R `whoami` /usr/local/lib/node_modules
    run npm install -g grunt-cli bower
}

setup_gitconfig () {
    if ! [ -f git/gitconfig.symlink ]
    then
        info 'setup gitconfig'

        user '- What is your github author name?'
        read -e git_authorname
        user '- What is your github author email?'
        read -e git_authoremail

        sed -e "s/AUTHORNAME/$git_authorname/g" -e "s/AUTHOREMAIL/$git_authoremail/g" git/gitconfig.symlink.example > git/gitconfig.symlink

        success 'gitconfig completed'
    fi
}

link_file () {
  local src=$1 dst=$2

  local overwrite= backup= skip=
  local action=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
  then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then

      local currentSrc="$(readlink $dst)"

      if [ "$currentSrc" == "$src" ]
      then

        skip=true;

      else

        user "File already exists: $(basename "$src"), what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        read -n 1 action

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac

      fi

    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == "true" ]
    then
      rm -rf "$dst"
      success "removed $dst"
    fi

    if [ "$backup" == "true" ]
    then
      mv "$dst" "${dst}.backup"
      success "moved $dst to ${dst}.backup"
    fi

    if [ "$skip" == "true" ]
    then
      success "skipped $src"
    fi
  fi

  if [ "$skip" != "true" ]  # "false" or empty
  then
    ln -s "$1" "$2"
    success "linked $1 to $2"
  fi
}

install_dotfiles () {
    user '- do you want to install dotfiles? (Y/n)'
    read -n 1 action
    br

    if [ "$action" == 'n' ]
    then
        return
    fi

    info 'installing dotfiles'

    local overwrite_all=false backup_all=false skip_all=false

    # symlink all files ending in .symlink
    for src in $(find "$DOTFILES_ROOT" -maxdepth 2 -name '*.symlink')
    do
        dst="$HOME/.$(basename "${src%.*}")"
        link_file "$src" "$dst"
    done

    # for all directires with a .dirsymlink file in them,
    # symlink those files into a directory instead of directly to $HOME/
    for src in `find $DOTFILES_ROOT -maxdepth 2 -name *.dirsymlink`
    do
        parent_dir="`dirname \"${src%.*}\"`"
        dst_dir="$HOME/.`basename \"${parent_dir%.*}\"`/"
        dst_file="`basename \"${src%.*}\"`"
        dst="$dst_dir$dst_file"

        if ! [ -d "$dst_dir" ]
        then
            mkdir "$dst_dir"
            success "created $dst_dir"
        fi

        link_file "$src" "$dst"
    done
}

install_pip () {
    which pip &>/dev/null
    if [ $? != 0 ]
    then
        sudo -v
        info "downloading and installing pip..."
        run curl -O https://bootstrap.pypa.io/get-pip.py
        run sudo python2.7 get-pip.py
        success "pip installed."
    fi
}

install_virtualenvwrapper () {
    if [ ! -f /usr/local/bin/virtualenvwrapper.sh ]
    then
        sudo -v
        info "installing virtualenvwrapper..."
        run sudo -A pip install virtualenvwrapper
        success "virtualenvwrapper installed."
    fi
}

install_brew_dependencies () {
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

install_applications () {
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

change_shell_to_zsh () {
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


# bootstrap it!
sudo -v
setup_gitconfig
install_node
install_dotfiles
install_pip
install_virtualenvwrapper
install_brew_dependencies
install_applications
setup_git_repos
change_shell_to_zsh

success "bootstrap completed!"
