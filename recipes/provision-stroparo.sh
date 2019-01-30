#!/usr/bin/env bash

PROGNAME="provision-stroparo.sh"


_step_base_system () {
  ${STEP_BASE_SYSTEM_DONE:-false} && return
  [ -e /etc/sudoers ] && ! sudo grep -q "$USER" /etc/sudoers && (echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers)
  mkdir ~/workspace >/dev/null 2>&1 ; ls -d -l ~/workspace || exit $?
  bash -c "$(curl -LSf "https://bitbucket.org/stroparo/runr/raw/master/entry.sh" || curl -LSf "https://raw.githubusercontent.com/stroparo/runr/master/entry.sh")" entry.sh apps shell
  source "${DS_HOME:-$HOME/.ds}/ds.sh" || exit $?
  export STEP_BASE_SYSTEM_DONE=true
}


_step_self_provision () {
  if ! ${DS_LOADED:-false} ; then
    . "${DS_HOME:-$HOME/.ds}/ds.sh" || exit $?
  fi
  dsplugin.sh "stroparo@bitbucket.org/stroparo/ds-stroparo" \
    || dsplugin.sh "stroparo@github.com/stroparo/ds-stroparo"
  dsload || . "${DS_HOME:-$HOME/.ds}/ds.sh" || exit $?
}


_step_setup () {
  runr dotfiles
  runr git
  runr provision

  selects-python-stroparo.sh
  st-conf-git.sh
}


_main () {
  _step_base_system
  _step_self_provision
  _step_setup
}


_main "$@"
