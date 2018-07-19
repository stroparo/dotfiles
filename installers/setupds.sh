#!/usr/bin/env bash

# Install Daily Shells & DS-Extras plugin

PROGNAME=setupds.sh

# #############################################################################
# Globals

export DS_SETUP_URL="https://raw.githubusercontent.com/stroparo/ds/master/setup.sh"

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

# #############################################################################
# Helpers

_print_bar () {
  echo "################################################################################"
}

_print_header () {
  echo "################################################################################"
  echo "$@"
  echo "################################################################################"
}

# #############################################################################
_print_header "Daily Shells"

bash -c "$(${DLPROG} ${DLOPT} "${DS_SETUP_URL}")"

# #############################################################################
# DS-Extras

. "${DS_HOME:-$HOME/.ds}/ds.sh"
if ! ${DS_LOADED:-false} ; then
  echo "${PROGNAME:+${PROGNAME}: }FATAL: Could not load Daily Shells." 1>&2
  exit 1
fi

_print_header "Daily Shells Extras"
dsextras_max_tries=3
while [ ! -e ~/.ds/functions/gitextras.sh ] ; do
  dsplugin.sh "stroparo/ds-extras"
  . "${DS_HOME:-$HOME/.ds}/ds.sh"
  dsextras_max_tries=$((dsextras_max_tries-1))
  if [ $dsextras_max_tries -le 0 ] ; then break ; fi
done

# #############################################################################
_print_bar
