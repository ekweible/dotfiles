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
    # Log working tree for visibility.
    warn "Mackup Changes:"
    git status --porcelain

    # Confirm before commiting and pushing.
    prompt "This will commit and push these changes and then update the submodule ref. Continue? (y/n)" -n 1
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        warn "Aborted."
        exit 1
    fi

    # Commit & push
    running "Pushing..."
    git add .
    git commit -m ',private-update.sh'
    git push origin main

    # Update submodule and commit the updated ref
    running "Updating submodule..."
    cd ..
    git submodule update --remote Mackup
    git add Mackup

    # Log working tree for visibility.
    warn "Changes:"
    git status --porcelain

    # Confirm before commiting and pushing the updated submodule ref
    prompt "This will commit and push these changes. Continue? (y/n)" -n 1
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        warn "Aborted."
        exit 1
    fi

    git commit -m ',private-update.sh'
    git push
else
    info "No changes in private Mackup"
    cd ..
fi

# Update the private submodule
if [ "$(git status --porcelain)" ]
then
    # Log working tree for visibility.
    warn "Private Changes:"
    git status --porcelain

    # Confirm before commiting and pushing.
    prompt "This will commit and push these changes and then update the submodule ref. Continue? (y/n)" -n 1
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        warn "Aborted."
        exit 1
    fi

    # Commit & push
    running "Pushing..."
    git add .
    git commit -m ',private-update.sh'
    git push origin $DOTFILES_PRIVATE_BRANCH

    # Update submodule and commit the updated ref
    running "Updating submodule..."
    cd ..
    git submodule update --remote private
    git add private

    # Log working tree for visibility.
    warn "Changes:"
    git status --porcelain

    # Confirm before commiting and pushing the updated submodule ref
    prompt "This will commit and push these changes. Continue? (y/n)" -n 1
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        warn "Aborted."
        exit 1
    fi

    git commit -m ',private-update.sh'
    git push
else
    info "No changes in private submodule"
fi

ok
