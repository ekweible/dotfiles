#!/usr/bin/env bash

set -e

# Allows this script to be run from anywhere
cd "$(dirname "${BASH_SOURCE}")/.."

# Source some utils
source ./lib_sh/echos.sh
source ./lib_sh/linkers.sh

# Run backup again to make sure all config files have been captured.
running "mackup backup..."
mackup backup

# Pull first so that conflicts are detected before committing.
running "Pulling..."
cd Mackup
git checkout main
git pull

# If there are no changes, exit. Nothing to do.
# This will detect changes to tracked files as well as the presence of new,
# untracked files. It will exclude gitignored files.
if [ "$(git status --porcelain)" ]
then
    # Commit and push changes in the submodule
    confirm_changes "dotfiles/Mackup"
    running "Pushing changes to submodule..."
    git add .
    git commit -m ',mackup-backup.sh'
    git push

    # Commit and push the updated submodule ref
    running "Updating submodule ref..."
    cd ..
    git add Mackup
    confirm_changes "dotfiles"
    git commit -m ',mackup-backup.sh'
    git push
else
    info "No changes."
fi

# Some config files cannot be shared between different profiles (like personal
# and work), so we allow the profile to hook into the post-backup stage here.
[ -f ./private/mackup-backup.sh ] && ./private/mackup-backup.sh

ok
