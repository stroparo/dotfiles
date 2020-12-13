#!/usr/bin/env bash

# Download and installation instructions at:
# https://apps.ankiweb.net/

PROGNAME="setupanki.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi
if type anki >/dev/null 2>&1 ; then echo "$PROGNAME: SKIP: Already installed" ; exit ; fi

echo "$PROGNAME: INFO: Anki setup started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Globals

ANKI_INSTALLER=$(mktemp)
ANKI_VERSION=2.1.37
WORK_DIR=/tmp

# Derived:
ANKI_URL="https://github.com/ankitects/anki/releases/download/${ANKI_VERSION}/anki-${ANKI_VERSION}-linux.tar.bz2"

# #############################################################################
# Main

curl -LSfs \
  "${ANKI_URL}"
  > "${WORK_DIR}/anki-${ANKI_VERSION}.tar.bz2" \
  && cd "${WORK_DIR}" \
  && tar xjf "${WORK_DIR}/anki-${ANKI_VERSION}.tar.bz2" \
  && cd anki*${ANKI_VERSION}*/ \
  && sudo ./install.sh

which anki

echo "$PROGNAME: COMPLETE: Anki setup"
echo
echo

exit
