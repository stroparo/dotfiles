#!/usr/bin/env bash

PROGNAME="setupnvm.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only." ; exit ; fi
if command -v nvm ; then echo "$PROGNAME: SKIP: already installed." ; exit ; fi


# Globals:
if ${IGNORE_SSL:-false} ; then export DLOPTEXTRA="-k ${DLOPTEXTRA}" ; fi
NVM_VERSION="v0.35.3"


echo "$PROGNAME: INFO: nvm (version: ${NVM_VERSION}) setup started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

if ! curl -o- ${DLOPTEXTRA} "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: There was some error." 1>&2
  exit 1
fi

echo "$PROGNAME: COMPLETE: nvm setup"
exit
