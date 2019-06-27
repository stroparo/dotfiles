#!/usr/bin/env bash

(uname | grep -i -q linux) || exit

PROGNAME="setupscreenkey.sh"

echo
echo "################################################################################"
echo "Setup screenkey GUI key logger for screencasts etc."

# #############################################################################
# Checks

# Check for idempotency
if type screenkey >/dev/null 2>&1 ; then
  echo "${PROGNAME:+$PROGNAME: }SKIP: screenkey already installed." 1>&2
  exit
fi

if ! type git ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: git unavailable." 1>&2
  exit 1
fi

if ! type slop ; then
  sudo apt update && sudo apt install slop
  if ! type slop ; then
    echo "${PROGNAME:+$PROGNAME: }FATAL: slop installation failed." 1>&2
    exit 1
  fi
fi

sudo mkdir /opt
sudo git clone https://gitlab.com/wavexx/screenkey.git /opt/screenkey
which screenkey
