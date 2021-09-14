#!/usr/bin/env bash

set -e

host=$1
name=$2
repo=$3

git remote add $name $(_git-url.sh $host $repo)
git remote -v
