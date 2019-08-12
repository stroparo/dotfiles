#!/usr/bin/env bash

PROGNAME="provision-cz.sh"


_step_base_system () {
  ${STEP_BASE_SYSTEM_DONE:-false} && return

  if [ -e /etc/sudoers ] && ! sudo grep -q "${USER}.*ALL" /etc/sudoers ; then
    echo
    echo "Add this line to your sudoers file:"
    echo "$USER ALL=(ALL) NOPASSWD: ALL"
    echo "Press any key to continue..."
    read dummy
    su - -c visudo
  fi

  mkdir ~/workspace >/dev/null 2>&1 ; ls -d -l ~/workspace || exit $?

  bash -c "$(curl ${DLOPTEXTRA} -LSf "https://bitbucket.org/stroparo/runr/raw/master/entry.sh" \
    || curl ${DLOPTEXTRA} -LSf "https://raw.githubusercontent.com/stroparo/runr/master/entry.sh")" \
    entry.sh apps shell

  source "${DS_HOME:-$HOME/.ds}/ds.sh" || exit $?

  export STEP_BASE_SYSTEM_DONE=true
}


_step_ds_custom () {
  dsplugin.sh "stroparo@bitbucket.org/stroparo/ds-cz"
  if [ ! -f "${DS_HOME}/envcz.sh" ] ; then
    echo "${PROGNAME}: FATAL: no 'envcz.sh' found in DS_HOME (${DS_HOME})."
    exit 1
  fi
}


_step_ds_stroparo () {
  export PROVISION_OPTIONS="${PROVISION_OPTIONS} gui xfce"
  export RUNR_QUIET=true
  runr -c provision-stroparo
}


_step_expedite_pre_existing () {
  if [ -d "${MOUNTS_PREFIX}/z" ] ; then
    git clone "https://stroparo@bitbucket.org/stroparo/handy.git" "${MOUNTS_PREFIX}/z/handy"

    if [ -f "${MOUNTS_PREFIX}/z/gitcred.txt" ] ; then
      git config --global credential.helper "store --file=${MOUNTS_PREFIX}/z/gitcred.txt"
    fi
  fi
}


_step_custom () {

  _step_expedite_pre_existing
  _step_ds_custom
  _step_ds_stroparo

  bash "${DS_HOME:-$HOME/.ds}"/recipes/cz-conf-git.sh
  bash "${DS_HOME:-$HOME/.ds}"/scripts/czsetupautostart.sh

  echo
  echo "==> czsetup.sh <=="
  echo
  echo "Review script \$DS_HOME/.../cz*filesystem*.sh" 1>&2
  echo "... and only then run czsetup.sh." 1>&2
  echo
}


_main () {
  _step_base_system
  _step_custom
}


_main "$@"
