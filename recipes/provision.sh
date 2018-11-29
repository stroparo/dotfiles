#!/usr/bin/env bash

# Base
bash "${RUNR_DIR:-.}"/recipes/apps.sh
bash "${RUNR_DIR:-.}"/recipes/shell.sh

# Desktop
if ! ${NODESKTOP:-false} ; then
  if [ "$1" = "workstation" ] ; then
    bash "${RUNR_DIR:-.}"/recipes/base-el7-gui.sh
    bash "${RUNR_DIR:-.}"/recipes/xfce.sh
    bash "${RUNR_DIR:-.}"/recipes/base-el7-gui-fonts.sh
    bash "${RUNR_DIR:-.}"/installers/setupchrome.sh
    bash "${RUNR_DIR:-.}"/installers/setuprdp.sh xfce
  else
    bash "${RUNR_DIR:-.}"/recipes/xfce.sh
    bash "${RUNR_DIR:-.}"/recipes/apps-desktop.sh
  fi
  bash "${RUNR_DIR:-.}"/code/code.sh
  bash "${RUNR_DIR:-.}"/recipes/subl.sh
  bash "${RUNR_DIR:-.}"/recipes/powerline-fonts.sh
fi

# System
bash "${RUNR_DIR:-.}"/recipes/fix.sh

# Dev platforms
bash "${RUNR_DIR:-.}"/installers/setuppython.sh
bash "${RUNR_DIR:-.}"/installers/setuprust.sh

# Dev tools
bash "${RUNR_DIR:-.}"/installers/setupdocker.sh
bash "${RUNR_DIR:-.}"/installers/setupdocker-compose.sh
bash "${RUNR_DIR:-.}"/installers/setupexa.sh
bash "${RUNR_DIR:-.}"/installers/setupsdkman.sh
bash "${RUNR_DIR:-.}"/installers/setupvim.sh python3
