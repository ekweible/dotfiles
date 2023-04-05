#!/usr/bin/env bash

setup_brew_env_if_missing () {
    if ! command -v "brew" >/dev/null 2>&1
    then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
}
