#!/usr/bin/env bash

echo
echo "################################################################################"
echo "Setup Docker..."

# #############################################################################
# Checks

if !(uname -a | grep -i -q linux) ; then
  echo "SKIP: Only Linux is supported." 1>&2
  exit
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
# Finish

echo "FINISHED Docker setup"
echo
