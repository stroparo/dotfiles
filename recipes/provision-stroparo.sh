#!/usr/bin/env bash

: ${PROGNAME:=provision-stroparo.sh}
: ${RUNR_DIR:=${RUNR_DIR:-${PWD}}}

REPO_DS_ST="stroparo@bitbucket.org/stroparo/ds-stroparo"
REPO_DS_ST_ALTN="stroparo@github.com/stroparo/ds-stroparo"

# Recipes:
if [ -z "${PROVISION_OPTIONS}" ] ; then
  export PROVISION_OPTIONS="base gui chrome golang nodejs python rust"
  bash "${RUNR_DIR}"/recipes/provision.sh
fi
bash "${RUNR_DIR}"/recipes/dotfiles.sh
bash "${RUNR_DIR}"/recipes/git.sh

# Daily Shells setups:
if ! source "${RUNR_DIR:-.}"/helpers/dsenforce.sh ; then exit 1 ; fi
if ! (dsplugin.sh "$REPO_DS_ST" || dsplugin.sh "$REPO_DS_ST_ALTN") ; then exit 1 ; fi
bash "${DS_HOME:-$HOME/.ds}"/scripts/dsconfgit.sh
bash "${DS_HOME:-$HOME/.ds}"/scripts/selects-python-stroparo.sh
