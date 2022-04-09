#!/usr/bin/env bash

PROGNAME="provision-cz.sh"
: ${RUNR_DIR:=${RUNR_DIR:-${PWD}}}

ISLINUX=false; if (uname | grep -i -q linux) ; then ISLINUX=true ; fi
REPO_BASE_BB="stroparo@bitbucket.org/stroparo"
REPO_BASE_GH="stroparo@github.com/stroparo"

# #############################################################################
# Basic provisioning

export PROVISION_OPTIONS="base sudonopasswd apps"
bash "${RUNR_DIR}"/recipes/provision.sh

# #############################################################################
# Scripting Library setups

source "${RUNR_DIR:-.}"/helpers/sidraenforce.sh

if [ -d "${DEV}/ds-cz" ] ; then appendunique "${REPO_BASE_GH}/ds-cz" "${ZDRA_PLUGINS_FILE:-${HOME}/.zdraplugins}" ; fi
zdrahashplugins.sh
if ! (zdraplugin.sh "${REPO_BASE_GH}/ds-cz" || zdraplugin.sh "${REPO_BASE_BB}/ds-cz") ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: 'ds-cz' shell plugin installation error." 1>&2
  exit 1
fi
zdraload

bash "${ZDRA_HOME:-$HOME/.zdra}"/scripts-dsc-pc/czpc.sh

# #############################################################################
# Recipes

source "${RUNR_DIR}"/recipes/provision-stroparo.sh  # After SIDRA Scripting Library setup.


# Configure:
bash "${RUNR_DIR}"/recipes-conf/coredump-disable.sh
bash "${RUNR_DIR}"/recipes-conf/ssh-hostkeyalgorithms.sh


# Apps - CLI - Prioritary (devel etc.)
if ${ISLINUX} ; then
  bash "${RUNR_DIR}"/recipes/python.sh
  bash "${RUNR_DIR}"/installers/setuprust.sh

  # Tools:
  bash "${RUNR_DIR}"/installers/setupdocker.sh
  bash "${RUNR_DIR}"/installers/setupdocker-compose.sh
  bash "${RUNR_DIR}"/installers/setupeditorconfig.sh
  bash "${RUNR_DIR}"/installers/setupexa.sh  # Deps: Rust
fi


# Apps - GUI
if ${ISLINUX} ; then
  bash "${RUNR_DIR}"/installers/setupchrome.sh
  bash "${RUNR_DIR}"/recipes/apps-gui.sh
  bash "${RUNR_DIR}"/recipes/apps-yay-gui.sh
  # bash "${RUNR_DIR}"/installers/setupinsomnia.sh
  if which dpkg >/dev/null 2>&1 ; then
    if sudo dpkg -s xfce4-panel >/dev/null 2>&1 ; then
      bash "${RUNR_DIR}"/installers/setupvnc.sh
      bash "${RUNR_DIR}"/recipes/xfce.sh
    fi
  else
    :
    # TODO Include test for Arch here
  fi
fi
if ${ISLINUX} ; then
  bash "${RUNR_DIR}"/recipes/keyb-ez.sh
fi
bash "${RUNR_DIR}"/recipes/subl.sh
bash "${RUNR_DIR}"/recipes/vsc.sh


echo
echo
echo "Suggested recipes to run later on:"
echo "conf-jetbrains"
echo "setupgolang"
echo "setupgotools"
echo "vim"
echo
echo "Suggested scripts in stroparo/sidra to run later on:"
echo "selects-python-stroparo.sh"
echo
echo

exit
