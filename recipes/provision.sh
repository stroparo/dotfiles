#!/usr/bin/env bash

# PROVISION_OPTIONS variable may contain any or all of these flags:
# - gui[ linux]
#   - el7
#   - xfce
#   - noapps|[chrome [edu]]
#   - nodevel
#   - nofonts
# - nodevel

# #############################################################################
# Globals

export ISLINUX=false
if (uname | grep -i -q linux) ; then
  export ISLINUX=true
fi

# #############################################################################
# Desktop helpers for Linux

_desktop_linux_el7 () {
  if [[ $PROVISION_OPTIONS != *el7* ]] ; then return ; fi

  bash "${RUNR_DIR:-.}"/recipes/base-el7-gui.sh
  bash "${RUNR_DIR:-.}"/recipes/base-el7-gui-fonts.sh
}

_desktop_linux_xfce () {
  if [[ $PROVISION_OPTIONS != *xfce* ]] ; then return ; fi

  bash "${RUNR_DIR:-.}"/recipes/xfce.sh
}

_desktop_linux_apps () {
  if [[ $PROVISION_OPTIONS != *noapps* ]] ; then
    bash "${RUNR_DIR:-.}"/recipes/apps-desktop.sh
  fi

  # Specific apps:
  if [[ $PROVISION_OPTIONS = *chrome* ]] ; then bash "${RUNR_DIR:-.}"/installers/setupchrome.sh ; fi
  if [[ $PROVISION_OPTIONS = *edu* ]] ; then bash "${RUNR_DIR:-.}"/installers/setupanki.sh ; fi
}

_desktop_linux_apps_devel () {
  if [[ $PROVISION_OPTIONS = *nodevel* ]] ; then return ; fi

  :
}

_desktop_linux_fonts () {
  if [[ $PROVISION_OPTIONS = *nofonts* ]] ; then return ; fi

  bash "${RUNR_DIR:-.}"/installers/setuppowerfonts.sh
}

_desktop_linux_rdp () {
  if [[ $PROVISION_OPTIONS != *rdp* ]] ; then return ; fi

  if [[ $PROVISION_OPTIONS = *xfce* ]] ; then
    bash "${RUNR_DIR:-.}"/installers/setuprdp.sh xfce
  else
    # TODO review setuprdp with no args:
    # bash "${RUNR_DIR:-.}"/installers/setuprdp.sh
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
  _desktop_linux_apps_devel
  _desktop_linux_rdp
}

# #############################################################################
# Desktop helpers for any Operating System

_desktop_any_os_dev_tools () {
  if [[ $PROVISION_OPTIONS = *nodevel* ]] ; then return ; fi

  bash "${RUNR_DIR:-.}"/recipes/subl.sh
  # TODO implement bash "${RUNR_DIR:-.}"/recipes/vscodium.sh
}

_desktop_any_os () {
  if [[ $PROVISION_OPTIONS != *gui* ]] ; then return ; fi

  _desktop_any_os_dev_tools
}

# #############################################################################
# Development helpers

_dev_platforms_any_os () {
  :
}

_dev_platforms_linux () {
  if ! ${ISLINUX} ; then return ; fi

  bash "${RUNR_DIR:-.}"/recipes/python.sh
  bash "${RUNR_DIR:-.}"/installers/setupgolang.sh
  bash "${RUNR_DIR:-.}"/installers/setuprust.sh
}

_dev_platforms () {
  # _dev_platforms_any_os
  _dev_platforms_linux
}

_dev_tools_any_os () {
  bash "${RUNR_DIR:-.}"/installers/setupgotools.sh
  bash "${RUNR_DIR:-.}"/installers/setupsdkman.sh
}

_dev_tools_linux () {
  if ! ${ISLINUX} ; then return ; fi

  bash "${RUNR_DIR:-.}"/installers/setupdocker.sh
  bash "${RUNR_DIR:-.}"/installers/setupdocker-compose.sh
  bash "${RUNR_DIR:-.}"/installers/setupeditorconfig.sh
  bash "${RUNR_DIR:-.}"/installers/setupexa.sh
  bash "${RUNR_DIR:-.}"/installers/setuptmux.sh
  bash "${RUNR_DIR:-.}"/recipes/vim.sh
}

_dev_tools () {
  _dev_tools_any_os
  _dev_tools_linux
}

_devel () {
  if [[ $PROVISION_OPTIONS = *nodevel* ]] ; then return ; fi
  _dev_platforms
  _dev_tools
}

# #############################################################################
# System helpers

_sys_linux () {
  if ! ${ISLINUX} ; then return ; fi

  bash "${RUNR_DIR:-.}"/recipes/linux-fixes.sh
}

# #############################################################################

# Base
if ! ${STEP_BASE_SYSTEM_DONE:-false} ; then # Avoid redundancy with other provisioning scripts
  if [[ $PROVISION_OPTIONS != *noapps* ]] ; then
    bash "${RUNR_DIR:-.}"/recipes/apps.sh
  fi
  bash "${RUNR_DIR:-.}"/recipes/shell.sh
fi

_desktop_linux
_desktop_any_os
_devel
_sys_linux
