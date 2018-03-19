#!/usr/bin/env bash

# Cristian Stroparo's dotfiles - https://github.com/stroparo/dotfiles

# #############################################################################
# Check OS

if ! egrep -i -q 'debian|ubuntu' /etc/*release ; then
  echo "FATAL: Only Debian/Ubuntu based distros are allowed to call this script ($0)" 1>&2
  exit 1
fi

# #############################################################################
# Main

sudo apt update
sudo apt install -y build-essential dkms module-assistant
