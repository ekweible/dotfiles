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
git pull

# If there are no changes, exit. Nothing to do.
# This will detect changes to tracked files as well as the presence of new,
# untracked files. It will exclude gitignored files.
test -n "$(git status --porcelain)" || (ok "No changes." && exit 0)

# Log working tree for visibility.
warn "Changes:"
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
git commit -m 'dotfiles-private-update.sh'
git push origin main

# Update submodule ref
running "Updating submodule..."
cd ..
git submodule update private

ok
