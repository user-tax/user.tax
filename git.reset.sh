#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR

set -e

GREEN='\033[32m'
NC='\033[0m' # No Color

for p in $(fd "^.git$" \
  -E node_modules \
  -aIHt d ); do

to=$(dirname $p)
echo -e "$GREEN> $to$NC"

if [ -n "$1" ]; then
  msg=${@:1}
else
  msg=♨
fi

cmd="cd $to && gitreset $msg"
echo $cmd
bash -c "$cmd" &
done

wait
