#!/usr/bin/env bash

# Cristian Stroparo's dotfiles

echo ${BASH_VERSION:+-e} '\n\n==> Installing docker...' 1>&2

# #############################################################################
# Checks

if !(uname -a | grep -i -q linux) ; then
  echo "FATAL: Only Linux is supported." 1>&2
  exit 1
fi

# Check for idempotency
if type docker >/dev/null 2>&1 ; then
  echo "SKIP: Already installed." 1>&2
  exit
fi

# #############################################################################
# Install

sh -c "$(curl -fsSL https://get.docker.com)"

# #############################################################################
# Post installation configuration

sudo usermod -aG docker "$USER"

# #############################################################################
# Verification

echo
sudo docker run hello-world

# #############################################################################
