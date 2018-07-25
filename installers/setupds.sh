#!/usr/bin/env bash

# Install Daily Shells & DS-Extras plugin

PROGNAME=setupds.sh

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

# #############################################################################
echo "################################################################################"
echo "Daily Shells"

bash -c "$(${DLPROG} ${DLOPT} "${DS_SETUP_URL}" || ${DLPROG} ${DLOPT} "${DS_SETUP_URL_ALT}")"

# #############################################################################
# DS-Extras

. "${DS_HOME:-$HOME/.ds}"/ds.sh
if ! ${DS_LOADED:-false} ; then
  echo "${PROGNAME:+${PROGNAME}: }FATAL: Could not load Daily Shells." 1>&2
  exit 1
fi

dsextras_max_tries=3
dsextras_trial_count=0
while [ ! -e "${DS_HOME:-$HOME/.ds}"/functions/gitextras.sh ] ; do
  "Daily Shells Extras installation trial $((dsextras_trial_count+1)) of ${dsextras_max_tries}..."
  dsplugin.sh "bitbucket.org/stroparo/ds-extras" \
    || dsplugin.sh "stroparo/ds-extras"
  dsextras_trial_count=$((dsextras_trial_count+1))
  if [ $dsextras_trial_count -ge $dsextras_max_tries ] ; then
    break
  fi
done

# #############################################################################
echo "################################################################################"
