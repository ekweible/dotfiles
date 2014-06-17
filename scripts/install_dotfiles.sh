#!/bin/sh

source $ZSH/scripts/includes.sh

DOTFILES_ROOT="`pwd`"

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

install_dotfiles