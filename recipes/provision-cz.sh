#!/usr/bin/env bash

PROGNAME="provision-cz.sh"

# #############################################################################
# Base

_shell_plus_cli_apps () {
  bash -c "$(curl ${DLOPTEXTRA} -LSf "https://bitbucket.org/stroparo/runr/raw/master/entry.sh" \
    || curl ${DLOPTEXTRA} -LSf "https://raw.githubusercontent.com/stroparo/runr/master/entry.sh")" \
    entry.sh apps shell
  source "${DS_HOME:-$HOME/.ds}/ds.sh" || exit $?
}


_sudo_setup () {
  if [ -e /etc/sudoers ] && ! sudo grep -q "${USER}.*ALL" /etc/sudoers ; then
    echo "Append:"
    echo "$USER ALL=(ALL) NOPASSWD: ALL"
    echo "... to the sudoers file."
    echo "Copy the above line then press any key to invoke 'sudo visudo'..."
    echo "If sudo visudo fails then enter root password for 'su visudo'..."
    read dummy
    sudo visudo
    if [ -e /etc/sudoers ] && ! sudo grep -q "${USER}.*ALL" /etc/sudoers ; then
      su - -c visudo
    fi
  fi
}


_make_workspace_dir () {
  mkdir ~/workspace >/dev/null 2>&1
  ls -d -l ~/workspace || exit $?
}


_step_base_system () {
  ${STEP_BASE_SYSTEM_DONE:-false} && return
  _sudo_setup
  _make_workspace_dir
  _shell_plus_cli_apps
  export STEP_BASE_SYSTEM_DONE=true
}


# #############################################################################
# Custom

_step_custom_ds_plugins () {
  dsplugin.sh "stroparo@bitbucket.org/stroparo/ds-cz"
  if [ $? -ne 0 ] ; then exit 99 ; fi
  source "${DS_HOME:-$HOME/.ds}/ds.sh" || exit $?
}


_helper_provision_encrypted_assets () {
  bash "${DS_HOME:-$HOME/.ds}"/scripts/czsetupfs.sh
  bash "${DS_HOME:-$HOME/.ds}"/scripts/czsynctc.sh

  git config --global --unset-all 'credential.helper'
  git config --global credential.helper "store --file=${CRYPT_DIR}/gitcred.txt"
  if grep -q "${CRYPT_MNT}" /etc/mtab ; then
    git clone "https://stroparo@bitbucket.org/stroparo/handys.git" "${CRYPT_DIR:-nanaobobo}/handys"
  fi
}


_step_custom_provision () {
  _helper_provision_encrypted_assets

  # Include rust in the provisioning options to satisfy setupexa:
  export PROVISION_OPTIONS="${PROVISION_OPTIONS} gui chrome golang python rust vim"
  runr -c provision-stroparo
  runr -c setupezkb

  bash "${DS_HOME:-$HOME/.ds}"/scripts/czsetupautostart.sh
}


_step_custom () {
  _step_custom_ds_plugins
  _step_custom_provision
}


# #############################################################################

_main () {
  _step_base_system
  _step_custom
}


_main "$@"
