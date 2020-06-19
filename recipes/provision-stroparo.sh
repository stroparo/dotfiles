#!/usr/bin/env bash

: ${PROGNAME:=provision-stroparo.sh}
: ${RUNR_DIR:=${RUNR_DIR:-${PWD}}}

REPO_DS_ST="stroparo@bitbucket.org/stroparo/ds-stroparo"
REPO_DS_ST_ALTN="stroparo@github.com/stroparo/ds-stroparo"
PROVISION_DEVEL="golang nodejs python rust"


if [ ${PROGNAME} != 'provision-stroparo.sh' ] ; then
  echo ; echo ; echo "${PROGNAME:+$PROGNAME: }INFO: provision-stroparo.sh steps from this point on..." 1>&2
  echo '...' ; echo ; echo
fi


# Recipes:
if [ -z "${PROVISION_OPTIONS}" ] ; then
  export PROVISION_OPTIONS="base gui xfce chrome ${PROVISION_DEVEL}"
else
  export PROVISION_OPTIONS="nodevel ${PROVISION_DEVEL}"
fi
bash "${RUNR_DIR}"/recipes/provision.sh
bash "${RUNR_DIR}"/recipes/dotfiles.sh
bash "${RUNR_DIR}"/recipes/git.sh

# Daily Shells setups:
source "${RUNR_DIR:-.}"/helpers/dsenforce.sh
if ! (dsplugin.sh "$REPO_DS_ST" || dsplugin.sh "$REPO_DS_ST_ALTN") ; then exit 1 ; fi
bash "${DS_HOME:-$HOME/.ds}"/scripts/dsconfgit.sh
bash "${DS_HOME:-$HOME/.ds}"/scripts/selects-python-stroparo.sh


if [ ${PROGNAME} != 'provision-stroparo.sh' ] ; then
  echo ; echo ; echo '...'
  echo "${PROGNAME:+$PROGNAME: }INFO: provision-stroparo.sh steps COMPLETE" 1>&2
  echo ; echo
fi
