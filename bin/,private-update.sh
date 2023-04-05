#!/usr/bin/env bash

set -e

# Allows this script to be run from anywhere
cd "$(dirname "${BASH_SOURCE}")/.."

# Source some utils
source ./lib_sh/echos.sh
source ./lib_sh/linkers.sh

# Pull first so that conflicts are detected before committing.
running "Pulling..."
cd private
git checkout $DOTFILES_PRIVATE_BRANCH
git pull
cd Mackup
git checkout main
git pull

# Update the private Mackup submodule
if [ "$(git status --porcelain)" ]
then
    # Commit and push changes in the submodule
    confirm_changes "dotfiles/private/Mackup"
    running "Pushing changes to submodule..."
    git add .
    git commit -m ',private-update.sh'
    git push

    # Commit and push the updated submodule ref
    running "Updating submodule ref..."
    cd ..
    git add Mackup
    confirm_changes "dotfiles/private"
    git commit -m ',private-update.sh'
    git push
else
    info "No changes in private Mackup"
    cd ..
fi

# Update the private submodule
if [ "$(git status --porcelain)" ]
then
    # Commit and push changes in the submodule
    confirm_changes "dotfiles/private"
    running "Pushing changes to submodule..."
    git add .
    git commit -m ',private-update.sh'
    git push

    # Commit and push the updated submodule ref
    running "Updating submodule ref..."
    cd ..
    git add private
    confirm_changes "dotfiles"
    git commit -m ',private-update.sh'
    git push
else
    info "No changes in private submodule"
fi

ok
