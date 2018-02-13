#!/usr/bin/env bash

# Daily Shells Extras extensions
# More instructions and licensing at:
# https://github.com/stroparo/ds-extras

# #############################################################################
# Check OS

if ! egrep -i -q 'debian|ubuntu' /etc/*release* ; then
  echo "FATAL: Only Debian/Ubuntu based distros are allowed to call this script ($0)" 1>&2
  exit 1
fi

# #############################################################################
# Main

sudo apt update
sudo apt install -y build-essential dkms module-assistant
