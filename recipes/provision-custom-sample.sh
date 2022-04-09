#!/usr/bin/env bash

PROGNAME="provision-custom-sample.sh"
: ${RUNR_DIR:=${RUNR_DIR:-${PWD}}}

ISLINUX=false; if (uname | grep -i -q linux) ; then ISLINUX=true ; fi

# #############################################################################
# Basic provisioning

export PROVISION_OPTIONS="base sudonopasswd apps"
bash "${RUNR_DIR}"/recipes/provision.sh

# #############################################################################
# Scripting Library setups

source "${RUNR_DIR:-.}"/helpers/sidraenforce.sh

if ! zdraplugin.sh "some repo url" ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: 'some sidra plugin' SIDRA Scripting Library plugin installation error." 1>&2
  exit 1
fi
zdraload

# #############################################################################
# Recipes

source "${RUNR_DIR}"/recipes/provision-stroparo.sh  # After SIDRA Scripting Library setups.


# Apps - CLI - Prioritary (devel etc.)
if ${ISLINUX} ; then
  # Most devel stacks commented as one should prefer containers/VM's for security:
  # bash "${RUNR_DIR}"/recipes/nodejs.sh
  bash "${RUNR_DIR}"/recipes/python.sh
  # bash "${RUNR_DIR}"/installers/setupgolang.sh
  # bash "${RUNR_DIR}"/installers/setupgotools.sh
  # bash "${RUNR_DIR}"/installers/setuprust.sh
  # bash "${RUNR_DIR}"/installers/setupsdkman.sh

  # Tools:
  bash "${RUNR_DIR}"/installers/setupdocker.sh
  bash "${RUNR_DIR}"/installers/setupdocker-compose.sh
  bash "${RUNR_DIR}"/installers/setupeditorconfig.sh
  bash "${RUNR_DIR}"/installers/setupexa.sh  # Must have Rust already setup
  # bash "${RUNR_DIR}"/recipes/vim.sh
fi
bash "${ZDRA_HOME:-$HOME/.zdra}"/scripts/selects-python-stroparo.sh
bash "${RUNR_DIR}"/installers/setuptmux.sh


# Apps - GUI - Prioritary (devel etc.)
bash "${RUNR_DIR}"/installers/setupchrome.sh
bash "${RUNR_DIR}"/recipes/subl.sh
bash "${RUNR_DIR}"/installers/setuppowerfonts.sh
bash "${RUNR_DIR}"/installers/setupinsomnia.sh
if type code ; then bash "${RUNR_DIR:-$PWD}"/recipes/conf-vscode.sh ; fi


# Apps - GUI - Etcetera
# bash "${RUNR_DIR}"/installers/setupbrave.sh
# bash "${RUNR_DIR}"/installers/setupbravebeta.sh
bash "${RUNR_DIR}"/recipes/apps-gui.sh
bash "${RUNR_DIR}"/recipes/keyb-ez.sh


# Apps - GUI - VSCodium
# bash "${RUNR_DIR:-$PWD}"/installers/setupvscodium.sh
# bash "${RUNR_DIR:-$PWD}"/recipes/conf-vscodium.sh
