#!/usr/bin/env bash

# Cristian Stroparo's dotfiles

: ${DEV:=${HOME}/workspace} ; export DEV

echo
echo "==> Workspace directory setup in the DEV global variable"

if [ ! -d "$DEV" ] ; then
  echo "Making the DEV directory '${DEV}'..."
  mkdir -p "${DEV}"
fi

ls -d -l "${DEV}"
