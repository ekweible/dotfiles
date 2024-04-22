#!/usr/bin/env bash

set -e

# Allows this script to be run from anywhere
cd "$(dirname "${BASH_SOURCE}")/.."
DOTFILES="$(pwd)"
DOTFILES_PRIVATE="$DOTFILES/../dotfiles_private"
DOTFILES_PROFILE="$DOTFILES/../dotfiles_profile"

# Source some utils
source ./lib_sh/brew.sh
source ./lib_sh/echos.sh
source ./lib_sh/linkers.sh

# During initial bootstrap, brew env may need to be setup for this shell session
setup_brew_env_if_missing

function restore() {
    repo="$(basename $(pwd))"
    running "[$repo] restoring..."

    # Pull latest before restoring
    running "[$repo] pulling..."
    git pull

    if [ -f Mackup/.mackup.cfg ]
    then
        # Link the mackup config and restore
        running "[$repo] mackup restore..."
        link_file "$(pwd)/Mackup/.mackup.cfg" "$HOME/.mackup.cfg"
        mackup restore --force
        mackup uninstall --force # Workaround for https://github.com/lra/mackup/issues/1924, found here: https://github.com/lra/mackup/issues/1924#issuecomment-2032982796
    fi
}

# Step 1: restore from the main dotfiles repo
restore

# Step 2: restore from the private dotfiles repo
cd "$DOTFILES_PRIVATE"
restore

# Step 3: restore from the profile-specific dotfiles repo
cd "$DOTFILES_PROFILE"
restore

ok
