#!/usr/bin/env bash

# Install Daily Shells & DS-Extras plugin

PROGNAME=setupds.sh

echo
echo "################################################################################"
echo "Daily Shells setup \$0='$0'"

# #############################################################################
# Globals

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
  bash -c "$(${DLPROG} ${DLOPT} "${DS_SETUP_URL}" || ${DLPROG} ${DLOPT} "${DS_SETUP_URL_ALT}")"

  # DS Extras
  if [ ! -e "${DS_HOME:-$HOME/.ds}"/functions/gitextras.sh ] ; then
    if ! ${DS_LOADED:-false} ; then
      . "${DS_HOME:-$HOME/.ds}"/ds.sh
    fi
    if ! ${DS_LOADED:-false} ; then
      echo "${PROGNAME:+${PROGNAME}: }FATAL: Could not load Daily Shells." 1>&2
      exit 1
    fi

    dsextras_max_tries=3
    dsextras_trial_count=0
    while [ ! -e "${DS_HOME:-$HOME/.ds}"/functions/gitextras.sh ] ; do
      echo "Daily Shells Extras installation trial $((dsextras_trial_count+1)) of ${dsextras_max_tries}..."
      dsplugin.sh "bitbucket.org/stroparo/ds-extras" \
        || dsplugin.sh "stroparo/ds-extras"
      dsextras_trial_count=$((dsextras_trial_count+1))
      if [ $dsextras_trial_count -ge $dsextras_max_tries ] ; then
        break
      fi
    done
  fi
}


_main () {
  if [ -z "${DS_HOME}" ] && [ ! -f "${HOME}/.ds/ds.sh" ] ; then
    _install_fresh
  elif [ -f "${HOME}/.ds/ds.sh" ] ; then
    . "${HOME}/.ds/ds.sh" && dsupgrade
  fi
  echo "${PROGNAME}: FINISHED Daily Shells setup"
  echo
}


_main "$@" || exit $?
