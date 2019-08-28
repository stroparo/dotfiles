#!/usr/bin/env bash

PROGNAME="setupanki.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi
if type anki >/dev/null 2>&1 ; then echo "$PROGNAME: SKIP: Already installed" ; exit ; fi

echo "$PROGNAME: INFO: Anki setup started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Globals

ANKI_INSTALLER=$(mktemp)
ANKI_VERSION=2.0.47
WORK_DIR=/tmp

# #############################################################################
# Main

curl -LSfs \
  "https://apps.ankiweb.net/downloads/current/anki-${ANKI_VERSION}-amd64.tar.bz2" \
  > "${WORK_DIR}/anki-${ANKI_VERSION}-amd64.tar.bz2" \
  && cd "${WORK_DIR}" \
  && tar xjf "${WORK_DIR}/anki-${ANKI_VERSION}-amd64.tar.bz2" \
  && cd "anki-${ANKI_VERSION}" \
  && sudo make install

which anki

echo "$PROGNAME: COMPLETE: Anki setup"
exit
