#!/usr/bin/env bash

# Cristian Stroparo's dotfiles - https://github.com/stroparo/dotfiles

: ${DEV:=${HOME}/workspace} ; export DEV

echo
echo "==> Setting up the workspace directory (DEV global)..."

if [ ! -d "$DEV" ] ; then
  echo "Making the DEV directory '${DEV}'..."
  mkdir -p "${DEV}"
fi

ls -d -l "${DEV}"
