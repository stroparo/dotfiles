#!/usr/bin/env bash

if ! which git >/dev/null 2>&1 ; then
  echo "deploygit: SKIP: no git available" 1>&2
  exit
fi

git config --global core.excludesfile ~/.gitignore_global
