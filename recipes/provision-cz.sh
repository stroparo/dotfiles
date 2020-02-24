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

_step_expedite_pre_existing () {

  if [ -d "${MOUNTS_PREFIX}/z" ] ; then
    git clone "https://stroparo@bitbucket.org/stroparo/handy.git" "${MOUNTS_PREFIX}/z/handy"
    git config --global credential.helper "store --file=${MOUNTS_PREFIX}/z/gitcred.txt"
  fi
}


_step_custom_ds_plugins () {

  dsplugin.sh "stroparo@bitbucket.org/stroparo/ds-cz"

  if [ ! -f "${DS_HOME}/envcz.sh" ] ; then
    echo "${PROGNAME}: FATAL: no 'envcz.sh' found in DS_HOME (${DS_HOME})."
    exit 1
  fi
}


_step_custom_provision () {
  export PROVISION_OPTIONS="${PROVISION_OPTIONS} gui xfce chrome edu"
  runr -c provision-stroparo
  runr -c setupez
}


_step_custom () {

  _step_expedite_pre_existing
  _step_custom_ds_plugins
  _step_custom_provision

  source "${DS_HOME:-$HOME/.ds}/ds.sh" || exit $?

  bash "${DS_HOME:-$HOME/.ds}"/scripts/czsetupautostart.sh

  echo
  echo "==> czsetup.sh <=="
  echo
  echo "Review script \$DS_HOME/.../cz*filesystem*.sh" 1>&2
  echo "... and only then run czsetup.sh." 1>&2
  echo
}

# #############################################################################

_main () {
  _step_base_system
  _step_custom
}


_main "$@"
