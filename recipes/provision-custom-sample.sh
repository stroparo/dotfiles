#!/usr/bin/env bash

PROGNAME="provision-custom-sample.sh"
: ${RUNR_DIR:=${RUNR_DIR:-${PWD}}}

# Recipes:
export PROVISION_OPTIONS="base sudonopasswd gui brave golang python rust"
bash "${RUNR_DIR}"/recipes/provision.sh

# Daily Shells setups:
source "${RUNR_DIR:-.}"/helpers/dsenforce.sh
# if ! dsplugin.sh "some repo url" ; then exit 1 ; fi
bash "${DS_HOME:-$HOME/.ds}"/scripts/pipinstall.sh pipenv

# Recipes depending on prior custom Daily Shells setups:
# source "${RUNR_DIR}"/recipes/provision-stroparo.sh
