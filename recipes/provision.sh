#!/usr/bin/env bash

# PROVISION_OPTIONS variable may contain any or all of these flags:
# - base  # apps, shell etc.
# -   sudonopasswd
# - gui[ linux]
#   - el7
#   - xfce
#   - noapps|[chrome] [edu]
#   - nodevel
#   - nofonts
#   - rdp
# - [nodevel] [golang] [nodejs] [python] [rust]  // i.e. platforms are not affected by 'nodevel'

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
  if ! test -d ~/workspace ; then
    exit $?
  fi

  if [[ $PROVISION_OPTIONS != *noapps* ]] ; then
    bash "${RUNR_DIR}"/recipes/apps.sh
  fi

  bash "${RUNR_DIR}"/recipes/shell.sh
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

_desktop_linux_apps () {
  if [[ $PROVISION_OPTIONS = *noapps* ]] ; then return ; fi

  bash "${RUNR_DIR}"/recipes/apps-desktop.sh
}

_desktop_linux_apps_brave () {
  if [[ $PROVISION_OPTIONS != *brave* ]] ; then return ; fi

  bash "${RUNR_DIR}"/installers/setupbrave.sh
}

_desktop_linux_apps_chrome () {
  if [[ $PROVISION_OPTIONS != *chrome* ]] ; then return ; fi

  bash "${RUNR_DIR}"/installers/setupchrome.sh
}

_desktop_linux_apps_devel () {
  if [[ $PROVISION_OPTIONS = *nodevel* ]] ; then return ; fi

  bash "${RUNR_DIR}"/installers/setupinsomnia.sh
}

_desktop_linux_apps_edu () {
  if [[ $PROVISION_OPTIONS != *edu* ]] ; then return ; fi

  bash "${RUNR_DIR}"/installers/setupanki.sh
}

_desktop_linux_fonts () {
  if [[ $PROVISION_OPTIONS = *nofonts* ]] ; then return ; fi

  bash "${RUNR_DIR}"/installers/setuppowerfonts.sh
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
  _desktop_linux_fonts
  _desktop_linux_apps
  _desktop_linux_apps_brave
  _desktop_linux_apps_chrome
  _desktop_linux_apps_devel
  _desktop_linux_apps_edu
  _desktop_linux_rdp
}

# #############################################################################
# Desktop helpers for any Operating System

_desktop_any_os_dev_tools () {
  if [[ $PROVISION_OPTIONS = *nodevel* ]] ; then return ; fi

  bash "${RUNR_DIR}"/recipes/subl.sh
  bash "${RUNR_DIR}"/recipes/vscodium.sh
}

_desktop_any_os () {
  if [[ $PROVISION_OPTIONS != *gui* ]] ; then return ; fi

  _desktop_any_os_dev_tools
}

# #############################################################################
# Development helpers

_dev_platforms () {

  if ! ${ISLINUX} ; then return ; fi

  if [[ $PROVISION_OPTIONS = *golang* ]] ; then bash "${RUNR_DIR}"/installers/setupgolang.sh ; fi
  if [[ $PROVISION_OPTIONS = *nodejs* ]] ; then bash "${RUNR_DIR}"/recipes/nodejs.sh ; fi
  if [[ $PROVISION_OPTIONS = *python* ]] ; then bash "${RUNR_DIR}"/recipes/python.sh ; fi
  if [[ $PROVISION_OPTIONS = *rust* ]] ; then bash "${RUNR_DIR}"/installers/setuprust.sh ; fi
}

_dev_tools () {
  if [[ $PROVISION_OPTIONS = *nodevel* ]] ; then return ; fi

  if [[ $PROVISION_OPTIONS = *golang* ]] ; then bash "${RUNR_DIR}"/installers/setupgotools.sh ; fi
  if [[ $PROVISION_OPTIONS = *sdkman* ]] ; then bash "${RUNR_DIR}"/installers/setupsdkman.sh ; fi

  if ! ${ISLINUX} ; then return ; fi

  bash "${RUNR_DIR}"/installers/setupdocker.sh
  bash "${RUNR_DIR}"/installers/setupdocker-compose.sh
  bash "${RUNR_DIR}"/installers/setupeditorconfig.sh
  bash "${RUNR_DIR}"/installers/setupexa.sh
  bash "${RUNR_DIR}"/installers/setuptmux.sh
  if [[ $PROVISION_OPTIONS = *vim* ]] ; then bash "${RUNR_DIR}"/recipes/vim.sh ; fi
}

_devel () {
  _dev_platforms
  _dev_tools
}

# #############################################################################
# System helpers

_sys_linux () {
  if ! ${ISLINUX} ; then return ; fi

  bash "${RUNR_DIR}"/recipes/linux-fixes.sh
}

# #############################################################################

_step_base_system
_desktop_linux
_desktop_any_os
_devel
_sys_linux
