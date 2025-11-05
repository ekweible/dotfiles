#!/usr/bin/env bash

# Source shared echo helpers for pretty output
source "$HOME/.local/lib/dotfiles/echos.sh"

running "brew upgrade"
brew upgrade

running "brew upgrade --cask --greedy"
brew upgrade --cask --greedy

ok "All brew packages upgraded!"
