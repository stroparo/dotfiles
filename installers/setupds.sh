#!/usr/bin/env bash

# Install Daily Shells & DS-Extras plugin

PROGNAME=setupds.sh

echo
echo "################################################################################"
echo "Daily Shells setup \$0='$0'"

# #############################################################################
# Globals

export DS_HOME="${DS_HOME:-${HOME}/.ds}"
export DS_SETUP_URL="https://bitbucket.org/stroparo/ds/raw/master/setup.sh"
export DS_SETUP_URL_ALT="https://raw.githubusercontent.com/stroparo/ds/master/setup.sh"

if which curl >/dev/null 2>&1 ; then
  export DLPROG=curl
  export DLOPT='-LSfs'
elif which wget >/dev/null 2>&1 ; then
  export DLPROG=wget
  export DLOPT='-O -'
else
  echo "${PROGNAME:+${PROGNAME}: }FATAL: curl and wget missing" 1>&2
  exit 1
fi


_install_fresh () {

  # Forced unset eg for when in an old DS loaded session but having removed DS:
  export DS_LOADED=false

  bash -c "$(${DLPROG} ${DLOPT} "${DS_SETUP_URL}" || ${DLPROG} ${DLOPT} "${DS_SETUP_URL_ALT}")" setup.sh "${DS_HOME}"
}


_main () {
  if [ ! -f "${DS_HOME}/ds.sh" ] ; then
    _install_fresh
  elif [ -f "${HOME}/.ds/ds.sh" ] ; then
    . "${HOME}/.ds/ds.sh" && dsupgrade
  fi
  echo "${PROGNAME}: FINISHED Daily Shells setup"
  echo
}


_main "$@" || exit $?
