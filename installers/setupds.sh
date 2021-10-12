#!/usr/bin/env bash

PROGNAME=setupds.sh

echo "$PROGNAME: INFO: DRYSL - DRY Scripting Library setup started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Globals

export DS_INSTALL_DIR="${1:-\$HOME/.ds}"
export DS_HOME="$(eval echo "\"${DS_INSTALL_DIR}\"")"
export DS_SETUP_URL="https://bitbucket.org/stroparo/ds/raw/master/setup.sh"
export DS_SETUP_URL_ALT="https://raw.githubusercontent.com/stroparo/ds/master/setup.sh"

DS_SETUP_BASENAME="${DS_SETUP_URL##*/}"
: ${DS_SETUP_BASENAME:=setup.sh}
export DS_SETUP_BASENAME


# Setup the downloader program (curl/wget)
_no_download_program () {
  echo "${PROGNAME} (ds): FATAL: curl and wget missing" 1>&2
  exit 1
}
export DLOPTEXTRA
if which curl >/dev/null 2>&1 ; then
  export DLPROG=curl
  export DLOPT='-LSfs'
  export DLOUT='-o'
  if ${IGNORE_SSL:-false} ; then export DLOPTEXTRA="-k ${DLOPTEXTRA}" ; fi
elif which wget >/dev/null 2>&1 ; then
  export DLPROG=wget
  export DLOPT=''
  export DLOUT='-O'
else
  export DLPROG=_no_download_program
fi


_install_fresh () {

  # Forced unset eg for when in an old DS loaded session but having removed DS:
  export DS_LOADED=false

  bash -c "$(${DLPROG} ${DLOPT} ${DLOPTEXTRA} ${DLOUT} - "${DS_SETUP_URL}" \
    || ${DLPROG} ${DLOPT} ${DLOPTEXTRA} ${DLOUT} - "${DS_SETUP_URL_ALT}")" \
    setup.sh "${DS_INSTALL_DIR}"
}


_main () {
  if [ ! -f "${DS_HOME:-$HOME/.ds}/ds.sh" ] ; then
    _install_fresh
  elif [ -f "${DS_HOME:-$HOME/.ds}/ds.sh" ] ; then
    . "${DS_HOME:-$HOME/.ds}/ds.sh" && dsupgrade
  fi
  echo "${PROGNAME}: FINISHED DRYSL - DRY Scripting Library setup"
  echo
}


_main "$@" || exit $?
echo "$PROGNAME: COMPLETE: DRYSL - DRY Scripting Library setup"
exit
