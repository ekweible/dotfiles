#!/usr/bin/env bash

link_file () {
  local src=$1 dst=$2

  local overwrite= backup= skip=
  local action=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
  then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then

      local current_src="$(readlink $dst)"

      if [ "$current_src" == "$src" ]
      then
        skip=true;
      else
        read -n 1 -p $'\x1b[32;01m?\x1b[39;49;00m'" File already exists: $(basename "$src"), what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all? " action
        echo -e ""

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
      running "removing $dst"
      rm -rf "$dst"
      ok
    fi

    if [ "$backup" == "true" ]
    then
      running "moving $dst to ${dst}.backup"
      mv "$dst" "${dst}.backup"
      ok
    fi

    if [ "$skip" == "true" ]
    then
      running "skipping $src"
      ok
    fi
  fi

  if [ "$skip" != "true" ]  # "false" or empty
  then
    running "linking $1 to $2"
    ln -s "$1" "$2"
    ok
  fi
}
