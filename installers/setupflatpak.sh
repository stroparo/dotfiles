#!/usr/bin/env bash

PROGNAME="setupflatpak.sh"

echo "$PROGNAME: INFO: setup started..."
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

if grep -q 'ubuntu' /etc/*release ; then
  sudo apt-get update \
  && sudo apt-get install -y flatpak
  if type flatpak >/dev/null 2>&1 ; then
    flatpak remote-add --if-not-exists flathub 'https://flathub.org/repo/flathub.flatpakrepo'
  fi
else
  echo "${PROGNAME:+$PROGNAME: }SKIP: this OS is not handled by this script." 1>&2
  exit
fi

echo "${PROGNAME:+$PROGNAME: }COMPLETE"
echo
echo
