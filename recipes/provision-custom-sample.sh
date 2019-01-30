#!/usr/bin/env bash

PROGNAME="setupbox.sh"


_step_base_system () {
  ${STEP_BASE_SYSTEM_DONE:-false} && return
  [ -e /etc/sudoers ] && ! sudo grep -q "$USER" /etc/sudoers && (echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers)
  mkdir ~/workspace >/dev/null 2>&1 ; ls -d -l ~/workspace || exit $?
  bash -c "$(curl -LSf "https://bitbucket.org/stroparo/runr/raw/master/entry.sh" || curl -LSf "https://raw.githubusercontent.com/stroparo/runr/master/entry.sh")" entry.sh apps shell
  source "${DS_HOME:-$HOME/.ds}/ds.sh" || exit $?
  export STEP_BASE_SYSTEM_DONE=true
}


_step_custom () {
  # Daily Shells stuff:
  # dsplugin.sh "https://site/path/to/dsplugin/repo1.git"
  # dsplugin.sh "https://site/path/to/dsplugin/repo2.git"
  # dsplugin.sh ...
  # dsload || . "${DS_HOME:-$HOME/.ds}/ds.sh" || exit $?

  export PROVISION_OPTIONS="${PROVISION_OPTIONS} nogui"
  runr provision
  pipinstall.sh pipenv

  clonemygits
}


_main () {
  _step_base_system
  _step_custom
}


_main "$@"
