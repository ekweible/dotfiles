#!/usr/bin/env bash

set -e

# Allows this script to be run from anywhere
cd "$(dirname "${BASH_SOURCE}")/.."

# Source some utils
source ./lib_sh/brew.sh
source ./lib_sh/echos.sh
source ./lib_sh/linkers.sh

# During initial bootstrap, brew env may need to be setup for this shell session
setup_brew_env_if_missing

# Make sure we're on latest
running "Updating Mackup submodule..."
git submodule update --init --recursive Mackup

# During initial bootstrap, we may need to link the Mackup config file
test -e "$HOME/.mackup.cfg" || link_file $HOME/.config/dotfiles/Mackup/.mackup.cfg $HOME/.mackup.cfg

# Restore
running "Restoring..."
mackup restore

# Some config files cannot be shared between different profiles (like personal
# and work), so we allow the profile to hook into the post-restore stage here.
[ -f ./private/mackup-restore.sh ] && ./private/mackup-restore.sh

ok
