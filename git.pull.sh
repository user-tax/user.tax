#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR
set -ex

git_pull(){
  cd $(dirname $1)
  echo "\n\033[1;32m→ $(pwd)\033[0m\n"
  git pull -v && git pull origin main && git merge main
}

export -f git_pull

fd "\.git$" -aIHt d -x sh -c 'git_pull $1' sh
