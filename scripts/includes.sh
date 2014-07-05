#!/bin/sh

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

echo "includes"