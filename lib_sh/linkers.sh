#!/usr/bin/env bash

link_file () {
    local src=$1 dst=$2
    local backup=false
    local skip=false
    local overwrite=false
    local action=

    if [ -f ${dst} ] || [ -L ${dst} ]; then

        local current_src="$(readlink $dst)"

        if [ "$current_src" == "$src" ]; then
            skip=true
        else
            read -n 1 -p $'\x1b[32;01m?\x1b[39;49;00m'" File already exists: $(basename "$dst"), what do you want to do? [s]kip, [o]verwrite, [b]ackup? " action
            echo -e ""

            case "$action" in
                b )
                    backup=true;;
                o )
                    overwrite=true;;
                s )
                    skip=true;;
                * )
                    ;;
            esac
        fi
    fi

    if [ "$overwrite" == "true" ]; then
        running "removing $dst"
        rm -rf "$dst"
    fi

    if [ "$backup" == "true" ]; then
        running "moving $dst to ${dst}.bak"
        mv "$dst" "${dst}.bak"
    fi

    if [ "$skip" == "true" ]; then
        warn "skipped $src"
    fi

    if [ "$skip" != "true" ]; then
        running "linking $1 to $2"
        ln -s "$1" "$2"
    fi

    ok
}
