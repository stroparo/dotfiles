#!/usr/bin/env bash

PROGNAME=setupsidra.sh

echo "$PROGNAME: INFO: SIDRA Scripting Library setup started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Globals

export ZDRA_INSTALL_DIR="${1:-\$HOME/.zdra}"
export ZDRA_HOME="$(eval echo "\"${ZDRA_INSTALL_DIR}\"")"
export ZDRA_SETUP_URL="https://bitbucket.org/stroparo/sidra/raw/master/setup.sh"
export ZDRA_SETUP_URL_ALT="https://raw.githubusercontent.com/stroparo/sidra/master/setup.sh"

ZDRA_SETUP_BASENAME="${ZDRA_SETUP_URL##*/}"
: ${ZDRA_SETUP_BASENAME:=setup.sh}
export ZDRA_SETUP_BASENAME


# Setup the downloader program (curl/wget)
_no_download_program () {
  echo "${PROGNAME}: FATAL: curl and wget missing" 1>&2
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
  typeset confirm

  # Forced unset eg for when in an old SIDRA loaded session but having removed SIDRA:
  export ZDRA_LOADED=false

  if [ -f "${DEV}/sidra/setup.sh" ] ; then
    echo ${BASH_VERSION:+-e} "$PROGNAME: CONFIRM: Local version found. (Re)Hash from it?" "[y/N] \c"
    read confirm
    if [[ $confirm = [yY]* ]] ; then
      . "${DEV}/sidra/zdra00.sh"
      zdrahash
      return
    fi
  fi
  bash -c "$(cat "${DEV}/sidra/setup.sh" 2>/dev/null \
    || ${DLPROG} ${DLOPT} ${DLOPTEXTRA} ${DLOUT} - "${ZDRA_SETUP_URL}" \
    || ${DLPROG} ${DLOPT} ${DLOPTEXTRA} ${DLOUT} - "${ZDRA_SETUP_URL_ALT}")" \
    setup.sh "${ZDRA_INSTALL_DIR}"
}


_main () {
  if [ ! -f "${ZDRA_HOME:-$HOME/.zdra}/zdra.sh" ] ; then
    _install_fresh
  fi
  echo "${PROGNAME}: FINISHED SIDRA Scripting Library setup"
  echo
}


_main "$@" || exit $?
echo "$PROGNAME: COMPLETE: SIDRA Scripting Library setup"
exit
