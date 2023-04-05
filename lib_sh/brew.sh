#!/usr/bin/env bash

setup_brew_env_if_missing () {
    brew_bin=$(which brew) 2>&1 > /dev/null
    if [[ $? != 0 ]]
    then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
}
