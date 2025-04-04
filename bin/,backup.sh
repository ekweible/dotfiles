#!/usr/bin/env bash

set -e

# Allows this script to be run from anywhere
cd "$(dirname "${BASH_SOURCE}")/.."
DOTFILES="$(pwd)"
DOTFILES_PRIVATE="$DOTFILES/../dotfiles_private"
DOTFILES_PROFILE="$DOTFILES/../dotfiles_profile"

# Source some utils
source ./lib_sh/echos.sh
source ./lib_sh/linkers.sh

function backup() {
    repo="$(basename $(pwd))"
    running "[$repo] backing up..."
    if [ -f Mackup/.mackup.cfg ]
    then
        # Delete mackup config file symlinks before linking them again.
        running "[$repo] linking mackup config files..."
        rm "$HOME/.mackup.cfg"
        link_file "$(pwd)/Mackup/.mackup.cfg" "$HOME/.mackup.cfg"
        [ -d "$HOME/.mackup" ] && rm -r "$HOME/.mackup" && link_file "$(pwd)/Mackup/.mackup" "$HOME/.mackup"

        # Run backup to make sure all config files have been captured.
        running "[$repo] mackup backup..."
        mackup backup --force --verbose
        running "[$repo] mackup uninstall..."
        mackup uninstall --force # Workaround for https://github.com/lra/mackup/issues/1924, found here: https://github.com/lra/mackup/issues/1924#issuecomment-2032982796

        # Next, pull so that conflicts are detected before committing.
        running "[$repo] pulling..."
        git pull
    fi

    # Check for changes, confirm them, then commit and push them.
    if [ "$(git status --porcelain)" ]
    then
        # Commit and push changes
        confirm_changes "$repo"
        running "[$repo] Committing and pushing changes..."
        (git add . && git commit -m ',backup.sh' && git push) || true
    else
        info "No changes."
    fi
}

# Step 1: backup the main dotfiles repo
backup

# Step 2: backup the private dotfiles repo
cd "$DOTFILES_PRIVATE"
backup

# Step 3: backup the profile-specific dotfiles repo
cd "$DOTFILES_PROFILE"
backup

ok
