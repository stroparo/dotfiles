#!/usr/bin/env bash

# PROVISION_OPTIONS variable may contain any or all of these flags:
# - apps
# - base  # shell etc.
# -   sudonopasswd
# - gui[ linux]
#   - el7
#   - xfce
#   - rdp

# #############################################################################
# Globals

: ${RUNR_DIR:=${RUNR_DIR:-${PWD}}}
ISLINUX=false; if (uname | grep -i -q linux) ; then ISLINUX=true ; fi

# #############################################################################
# Base

_sudo_setup () {
  if [[ $PROVISION_OPTIONS != *sudonopasswd* ]] ; then return ; fi

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


_step_base_system () {
  if [[ $PROVISION_OPTIONS != *base* ]] ; then return ; fi

  _sudo_setup

  mkdir -p ~/workspace >/dev/null 2>&1
  if ! test -d ~/workspace && ! test -L ~/workspace ; then
    exit $?
  fi

  bash "${RUNR_DIR}"/recipes/shell.sh
}


_step_base_apps () {
  if [[ $PROVISION_OPTIONS != *apps* ]] ; then return ; fi

  bash "${RUNR_DIR}"/recipes/apps-cli.sh
  bash "${RUNR_DIR}"/recipes/apps-yay-cli.sh
}

# #############################################################################
# Desktop helpers for Linux

_desktop_linux_el7 () {
  if [[ $PROVISION_OPTIONS != *el7* ]] ; then return ; fi

  bash "${RUNR_DIR}"/recipes/base-el7-gui.sh
  bash "${RUNR_DIR}"/recipes/base-el7-gui-fonts.sh
}

_desktop_linux_xfce () {
  if [[ $PROVISION_OPTIONS != *xfce* ]] ; then return ; fi

  bash "${RUNR_DIR}"/recipes/xfce.sh
}

_desktop_linux_rdp () {
  if [[ $PROVISION_OPTIONS != *rdp* ]] ; then return ; fi

  if [[ $PROVISION_OPTIONS = *xfce* ]] ; then
    bash "${RUNR_DIR}"/installers/setuprdp.sh xfce
  else
    # TODO review setuprdp with no args:
    # bash "${RUNR_DIR}"/installers/setuprdp.sh
    :
  fi
}

_desktop_linux () {
  if ! ${ISLINUX} ; then return ; fi
  if [[ $PROVISION_OPTIONS != *gui* ]] ; then return ; fi

  _desktop_linux_el7
  _desktop_linux_xfce
  _desktop_linux_rdp
}

# #############################################################################
# System helpers

_sys_linux () {
  if ! ${ISLINUX} ; then return ; fi

  # bash "${RUNR_DIR}"/recipes/linux-fixes.sh
}

# #############################################################################

_step_base_system
_step_base_apps
_desktop_linux
_sys_linux
