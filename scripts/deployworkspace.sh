#!/usr/bin/env bash

# Cristian Stroparo's dotfiles - https://github.com/stroparo/dotfiles

echo
echo "==> Setting up workspace directory..."

export DEV="$HOME"/workspace
echo "Making the DEV directory '${DEV}'..."
mkdir -p "${DEV}"
ls -d -l "${DEV}"
