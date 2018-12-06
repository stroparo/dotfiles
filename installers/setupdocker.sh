#!/usr/bin/env bash

(uname | grep -i -q linux) || exit

PROGNAME="setupdocker.sh"

echo
echo "################################################################################"
echo "Setup Docker..."

# #############################################################################
# Checks

# Check for idempotency
if type docker >/dev/null 2>&1 ; then
  echo "${PROGNAME:+$PROGNAME: }SKIP: Docker is already installed." 1>&2
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

echo "${PROGNAME:+$PROGNAME: }COMPLETE: Docker setup complete"
echo
