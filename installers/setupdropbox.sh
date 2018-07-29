#!/usr/bin/env bash

echo
echo "################################################################################"
echo "Setup Dropbox..."

# #############################################################################
# Checks

if !(uname -a | grep -i -q linux) ; then
  echo "SKIP: Only Linux is supported." 1>&2
  exit
fi

# Check for idempotency
if [ -e ~/.dropbox-dist/dropboxd ] ; then
  echo "SKIP: Already installed." 1>&2
  exit
fi

# #############################################################################
# Main

cd ~
wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" \
  | tar xzf -

env DBUS_SESSION_BUS_ADDRESS='' "${HOME}"/.dropbox-dist/dropboxd > /dev/null 2>&1 &

# #############################################################################
# Finish

echo "FINISHED Dropbox setup"
echo
