#!/usr/bin/env bash

PROGNAME="provision-cz.sh"
: ${RUNR_DIR:=${RUNR_DIR:-${PWD}}}

REPO_DS_CZ="stroparo@bitbucket.org/stroparo/ds-cz"
REPO_DS_CZ_ALTN="stroparo@github.com/stroparo/ds-cz"

# Recipes:
export PROVISION_OPTIONS="base sudonopasswd gui xfce brave"
bash "${RUNR_DIR}"/recipes/provision.sh
bash "${RUNR_DIR}"/recipes/keyb-ez.sh

# Daily Shells setups:
source "${RUNR_DIR:-.}"/helpers/dsenforce.sh

if ! (dsplugin.sh "$REPO_DS_CZ" || dsplugin.sh "$REPO_DS_CZ_ALTN") ; then exit 1 ; fi
dsload
bash "${DS_HOME:-$HOME/.ds}"/scripts/czsetupfs.sh crypt cryptlinux data external c
bash "${DS_HOME:-$HOME/.ds}"/scripts/czsetupautostart.sh
bash "${DS_HOME:-$HOME/.ds}"/scripts/czsetupgitcred.sh
bash "${DS_HOME:-$HOME/.ds}"/scripts/czsynckeys.sh
bash "${DS_HOME:-$HOME/.ds}"/scripts/czsynctc.sh

# Recipes depending on prior custom Daily Shells setups:
source "${RUNR_DIR}"/recipes/provision-stroparo.sh
