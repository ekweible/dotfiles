#!/usr/bin/env bash

set -e

host=$1
repo=$2
name=$3
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

git clone $host:$repo $name
cd "${name:-$(basename "$repo" .git)}"
