#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR

direnv allow . && eval "$(direnv export $SHELL)"

set -ex

GIT="${GIT:-git@github.com:user-tax}"
GIT_CONF="${GIT_CONF:-git@github.com:user-tax/conf.git}"

if ! [ -x "$(command -v cargo)" ]; then
  echo "need install rust"
  exit
fi

if ! [ -x "$(command -v openresty)" ]; then
  if [ -x "$(command -v brew)" ]; then
    brew install openresty/brew/openresty
  else
    echo "not install openresty"
  fi
fi

cd $DIR
if [ ! -d "conf" ]; then
  git clone --recursive --depth=1 $GIT_CONF conf
fi

cd conf
direnv allow
cd $DIR


cargo_install() {
  if ! [ -x "$(command -v $1)" ]; then
    cargo install --locked ${2:-$1}
  fi
}
cargo_install watchexec watchexec-cli
cargo_install fd
cargo_install sd
cargo_install rtx rtx-cli
eval "$(rtx activate --quiet $(basename bash))"
rtx plugin add nodejs
rtx install

if ! [ -x "$(command -v bun)" ]; then
  PATH_add $HOME/.bun/bin
  if ! [ -x "$(command -v bun)" ]; then
    curl https://bun.sh/install | bash
  fi
fi

init() {
  if [ ! -d "$1" ]; then
    git clone --recursive --depth=1 $GIT/$1.git
    if [ -f "$1/.envrc" ]; then
      cd $1
      direnv allow .
      cd ..
    fi
  fi
}

init doc
init pkg
init styl
init ui
init api
init site

init ru
if [ ! -d "ru/target" ]; then
  direnv exec $DIR/ru ./ru/build.sh
fi
init docker_dev

mkdir -p lib
cd lib
init utax

cd $DIR/pkg
direnv exec . ./init.coffee
direnv exec . ./i18n.coffee
cd $DIR
