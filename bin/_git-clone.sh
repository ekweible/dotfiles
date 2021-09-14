#!/usr/bin/env bash

set -e

host=$1
repo=$2
name=$3

git clone $(_git-url.sh $host $repo) $name
cd "${name:-$(basename "$(_git-repo.sh $repo)" .git)}"
