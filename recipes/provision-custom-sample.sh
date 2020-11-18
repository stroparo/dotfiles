#!/usr/bin/env bash

PROGNAME="provision-custom-sample.sh"
: ${RUNR_DIR:=${RUNR_DIR:-${PWD}}}

ISLINUX=false; if (uname | grep -i -q linux) ; then ISLINUX=true ; fi

# #############################################################################
# Basic provisioning

export PROVISION_OPTIONS="base sudonopasswd apps"
bash "${RUNR_DIR}"/recipes/provision.sh

# #############################################################################
# Daily Shells setups

source "${RUNR_DIR:-.}"/helpers/dsenforce.sh

if ! dsplugin.sh "some repo url" ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: 'some ds plugin' Daily Shells plugin installation error." 1>&2
  exit 1
fi

# #############################################################################
# Recipes

source "${RUNR_DIR}"/recipes/provision-stroparo.sh  # After Daily Shells setups.


# Apps - CLI - Prioritary (devel etc.)
bash "${RUNR_DIR}"/recipes/nodejs.sh
bash "${RUNR_DIR}"/recipes/python.sh
bash "${RUNR_DIR}"/installers/setupgolang.sh
bash "${RUNR_DIR}"/installers/setupgotools.sh
bash "${RUNR_DIR}"/installers/setuprust.sh
if ${ISLINUX} ; then
  bash "${RUNR_DIR}"/installers/setupdocker.sh
  bash "${RUNR_DIR}"/installers/setupdocker-compose.sh
  bash "${RUNR_DIR}"/installers/setupeditorconfig.sh
  bash "${RUNR_DIR}"/installers/setupexa.sh  # Must have Rust already setup
  # bash "${RUNR_DIR}"/recipes/vim.sh
fi
bash "${DS_HOME:-$HOME/.ds}"/scripts/selects-python-stroparo.sh
bash "${RUNR_DIR}"/installers/setupsdkman.sh
bash "${RUNR_DIR}"/installers/setuptmux.sh


# Apps - GUI - Prioritary (devel etc.)
bash "${RUNR_DIR}"/installers/setupchrome.sh
bash "${RUNR_DIR}"/recipes/subl.sh
bash "${RUNR_DIR}"/installers/setuppowerfonts.sh
bash "${RUNR_DIR}"/installers/setupinsomnia.sh
if type code ; then bash "${RUNR_DIR:-$PWD}"/recipes/conf-vscode.sh ; fi


# Apps - GUI - Etcetera
bash "${RUNR_DIR}"/installers/setupanki.sh
# bash "${RUNR_DIR}"/installers/setupbrave.sh
# bash "${RUNR_DIR}"/installers/setupbravebeta.sh
# bash "${RUNR_DIR}"/installers/setupskype.sh
bash "${RUNR_DIR}"/recipes/apps-desktop.sh
bash "${RUNR_DIR}"/recipes/keyb-ez.sh


# Apps - GUI - VSCodium
# bash "${RUNR_DIR:-$PWD}"/installers/setupvscodium.sh
# bash "${RUNR_DIR:-$PWD}"/recipes/conf-vscodium.sh
