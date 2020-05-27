#!/usr/bin/env bash

PROGNAME="provision-custom-sample.sh"

# #############################################################################
# Base

_shell_plus_cli_apps () {
  bash -c "$(curl ${DLOPTEXTRA} -LSf "https://bitbucket.org/stroparo/runr/raw/master/entry.sh" \
    || curl ${DLOPTEXTRA} -LSf "https://raw.githubusercontent.com/stroparo/runr/master/entry.sh")" \
    entry.sh apps shell
  if ! . "${DS_HOME:-$HOME/.ds}/ds.sh" ; then echo "$PROGNAME: ERROR: DS source failure." ; exit $? ; fi
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
  # dsplugin.sh \
  #   "https://site/path/to/dsplugin/repo1.git" \
  #   "https://site/path/to/dsplugin/repo2.git"
  # if [ $? -ne 0 ] ; then exit 99 ; fi
  # source "${DS_HOME:-$HOME/.ds}/ds.sh" || exit $?
}


_step_custom_provision () {
  export PROVISION_OPTIONS="${PROVISION_OPTIONS} nogui"
  runr -c provision
}


_step_custom () {

  _step_custom_ds_plugins
  _step_custom_provision

  # Other steps:
  clonemygits
  pipinstall.sh pipenv
}

# #############################################################################

_main () {
  _step_base_system
  _step_custom
}


_main "$@"
