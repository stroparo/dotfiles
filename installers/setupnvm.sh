#!/usr/bin/env bash

PROGNAME="setupnvm.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only." ; exit ; fi
if command -v nvm ; then echo "$PROGNAME: SKIP: already installed." ; exit ; fi


# Globals:
if ${IGNORE_SSL:-false} ; then export DLOPTEXTRA="-k ${DLOPTEXTRA}" ; fi
NVM_VERSION="v0.35.3"
NVM_INSTALL_URL="https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh"
NVM_INIT_CODE='
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
'


echo "$PROGNAME: INFO: nvm (version: ${NVM_VERSION}) setup started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

if ! bash -c "curl -o- ${DLOPTEXTRA} \"${NVM_INSTALL_URL}\"" "${NVM_INSTALL_URL##*/}" ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: There was some error." 1>&2
  exit 1
fi
if ! grep -q "NVM_DIR=" ~/.bashrc ; then echo "${NVM_INIT_CODE}" >> ~/.bashrc ; fi
if ! grep -q "NVM_DIR=" ~/.zshrc ; then echo "${NVM_INIT_CODE}" >> ~/.zshrc ; fi

echo "$PROGNAME: COMPLETE: nvm setup"
echo
echo

exit
