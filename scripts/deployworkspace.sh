#!/usr/bin/env bash

echo
echo "==> Setting up workspace directory..."

export DEV="$HOME"/workspace
echo "Making the DEV directory '${DEV}'..."
mkdir -p "${DEV}"
ls -d -l "${DEV}"
