#!/usr/bin/env bash

# Cristian Stroparo's dotfiles - https://github.com/stroparo/dotfiles

echo
echo "==> Setting up the workspace directory (DEV global)..."

: ${DEV:=${HOME}/workspace} ; export DEV

if [ ! -d "$DEV" ] ; then
  echo "Making the DEV directory '${DEV}'..."
  mkdir -p "${DEV}"
fi

ls -d -l "${DEV}"
