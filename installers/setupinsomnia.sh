#!/usr/bin/env bash

PROGNAME="setupinsomnia.sh"
export PKGNAME="insomnia"
export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf
if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi
if which "${PKGNAME}" >/dev/null 2>&1 ; then echo "$PROGNAME: SKIP: already installed." ; exit ; fi


echo "$PROGNAME: INFO: setup started..."
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"


if egrep -i -q -r 'debian|ubuntu' /etc/*release ; then
  wget --quiet -O - https://insomnia.rest/keys/debian-public.key.asc \
    | sudo apt-key add -
  if ! sudo grep -q "insomnia" /etc/apt/sources.list.d/insomnia.list 2>/dev/null ; then
    echo "deb https://dl.bintray.com/getinsomnia/Insomnia /" \
      | sudo tee -a /etc/apt/sources.list.d/insomnia.list
  fi
  sudo apt-get update
  sudo apt-get install -y insomnia


else
  echo "${PROGNAME:+$PROGNAME: }SKIP: Distro not supported." 1>&2
fi


echo "${PROGNAME:+$PROGNAME: }COMPLETE"
echo
echo
