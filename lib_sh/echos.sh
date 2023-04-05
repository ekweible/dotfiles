#!/usr/bin/env bash

###
# some colorized echo helpers
# @author Adam Eivy
###

BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
LIME_YELLOW=$(tput setaf 190)
POWDER_BLUE=$(tput setaf 153)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)
BLINK=$(tput blink)
REVERSE=$(tput smso)
UNDERLINE=$(tput smul)

function br() {
    printf "\n"
}

function info() {
    printf "%s\n" "$CYAN[info]$NORMAL $1"
}

function ok() {
    printf "%s\n" "$GREEN[ok]$NORMAL $1"
}

function bot() {
    printf "\n%s\n" "$GREEN\[._.]/$NORMAL - $1"
}

function group() {
    printf "\n%s\n\n" "$YELLOW[-----]$NORMAL $1"
}

function prompt() {
    read -p $'\x1b[32;01m?\x1b[39;49;00m'" $1 " "${@:2}"
}

function confirm_changes() {
    path="$1"
    branch="$(git rev-parse --abbrev-ref HEAD)"

    # Log working tree for visibility.
    warn "Changes:"
    git status --porcelain

    # Confirm before commiting and pushing the updates
    prompt "This will commit and push the above changes to $CYAN$path$NORMAL on the branch $CYAN$branch$NORMAL. Continue? (y/n)" -n 1
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        warn "Aborted."
        exit 1
    fi
}

function running() {
    printf "%s\n" "$YELLOW ⇒ $NORMAL$1"
}

function warn() {
    printf "%s\n" "$YELLOW[warning]$NORMAL $1"
}

function error() {
    printf "%s\n" "$RED[error]$NORMAL $1"
}
