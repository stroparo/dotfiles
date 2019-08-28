#!/usr/bin/env bash

PROGNAME="setupscreenkey.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi
if type screenkey >/dev/null 2>&1 ; then echo "${PROGNAME:+$PROGNAME: }SKIP: screenkey already installed." ; exit ; fi
if ! type git ; then echo "${PROGNAME:+$PROGNAME: }FATAL: git unavailable." 1>&2 ; exit 1 ; fi

echo "$PROGNAME: INFO: Setup screenkey GUI key logger setup started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

if ! type slop ; then

  sudo apt update && sudo apt install slop

  if ! type slop ; then
    echo "${PROGNAME:+$PROGNAME: }FATAL: slop installation failed." 1>&2
    exit 1
  fi
fi

sudo mkdir /opt
sudo git clone "https://gitlab.com/wavexx/screenkey.git" /opt/screenkey
which screenkey

echo "$PROGNAME: COMPLETE: screenkey GUI key logger setup"
exit
