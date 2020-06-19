#!/usr/bin/env bash

PROGNAME="setupyarn.sh"
if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only." ; exit ; fi
if ! egrep -i -q -r 'debian|ubuntu' /etc/*release ; then echo "$PROGNAME: SKIP: Debian/Ubuntu-based Linux supported only." ; exit ; fi
if command -v yarn >/dev/null 2>&1 ; then echo "$PROGNAME: SKIP: already installed version 'yarn -v'." ; exit ; fi
if ${IGNORE_SSL:-false} ; then export DLOPTEXTRA="-k ${DLOPTEXTRA}" ; fi


echo "$PROGNAME: INFO: started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"


curl ${DLOPTEXTRA} -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
if ! sudo grep -q "yarn" /etc/apt/sources.list.d/yarn.list 2>/dev/null ; then
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
fi

sudo apt update \
  && sudo apt install --no-install-recommends yarn

which yarn
yarn -v


echo "$PROGNAME: COMPLETE"
echo
echo

exit
