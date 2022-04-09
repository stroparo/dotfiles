#!/usr/bin/env bash

: ${PROGNAME:=provision-stroparo.sh}
: ${RUNR_DIR:=${RUNR_DIR:-${PWD}}}

ISLINUX=false; if (uname | grep -i -q linux) ; then ISLINUX=true ; fi
REPO_BASE_BB="stroparo@bitbucket.org/stroparo"
REPO_BASE_GH="stroparo@github.com/stroparo"

if [ ${PROGNAME} != 'provision-stroparo.sh' ] ; then
  echo ; echo ; echo "${PROGNAME:+$PROGNAME: }INFO: provision-stroparo.sh steps from this point on..." 1>&2
  echo '...' ; echo ; echo
fi

# #############################################################################
# Basic provisioning

if [ -z "${PROVISION_OPTIONS}" ] ; then
  export PROVISION_OPTIONS="base apps"
  bash "${RUNR_DIR}"/recipes/provision.sh
fi

bash "${RUNR_DIR}"/recipes/dotfiles.sh
bash "${RUNR_DIR}"/recipes/git.sh

# #############################################################################
# Scripting Library setups

source "${RUNR_DIR:-.}"/helpers/sidraenforce.sh

if ! (zdraplugin.sh "${REPO_BASE_BB}/ds-stroparo" || zdraplugin.sh "${REPO_BASE_GH}/ds-stroparo") ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: 'ds-stroparo' shell plugin installation error." 1>&2
  exit 1
fi

if ! (zdraplugin.sh "${REPO_BASE_BB}/ds-js" || zdraplugin.sh "${REPO_BASE_GH}/ds-js") ; then
  echo "${PROGNAME:+$PROGNAME: }WARN: 'ds-js' shell plugin installation error." 1>&2
fi

bash "${ZDRA_HOME:-$HOME/.zdra}"/scripts-dsc-pc/st-conf-git.sh

# #############################################################################

if [ ${PROGNAME} != 'provision-stroparo.sh' ] ; then
  echo ; echo ; echo '...'
  echo "${PROGNAME:+$PROGNAME: }INFO: provision-stroparo.sh steps COMPLETE" 1>&2
  echo ; echo
fi
