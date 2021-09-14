#!/usr/bin/env bash

set -e

repo=$1
github="git@github.com:"
dotgit=".git"

if [[ "$repo" =~ "$github".* ]]; then
    # Given repo is a full ssh url.
    # Strip the hostname so we can set it to match a host in ~/.ssh/config
    repo=${repo#"$github"}
fi

if [[ ! "$repo" =~ .*"$dotgit" ]]; then
    # Repo does not have the .git extension, so add it.
    repo="$repo$dotgit"
fi

echo $repo
