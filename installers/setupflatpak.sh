#!/usr/bin/env bash

PROGNAME="setupflatpak.sh"

echo "$PROGNAME: INFO: setup started..."
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

if grep -q 'ubuntu' /etc/*release ; then
  sudo apt-get install flatpak
  flatpak remote-add --if-not-exists flathub 'https://flathub.org/repo/flathub.flatpakrepo'
else
  echo "${PROGNAME:+$PROGNAME: }SKIP: distro not supported." 1>&2
  exit
fi

echo "${PROGNAME:+$PROGNAME: }COMPLETE"
echo
echo
