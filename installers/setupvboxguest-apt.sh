#!/usr/bin/env bash

echo
echo "################################################################################"
echo "Setup VirtualBox guest for Debian based distributions"

# #############################################################################
# Check OS

if ! egrep -i -q -r 'debian|ubuntu' /etc/*release ; then
  echo "SKIP: Only Debian/Ubuntu based distros supported by '$0'" 1>&2
  exit
fi

# #############################################################################
# Main

sudo apt update
sudo apt install -y build-essential dkms module-assistant

# #############################################################################
# Finish

echo "FINISHED VirtualBox guest additions setup"
echo
