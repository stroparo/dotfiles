#!/usr/bin/env bash

# Base
bash "${RUNR_DIR:-.}"/recipes/shell.sh
bash "${RUNR_DIR:-.}"/recipes/apps.sh

# Desktop
bash "${RUNR_DIR:-.}"/recipes/base-el7-gui.sh
bash "${RUNR_DIR:-.}"/recipes/base-el7-gui-fonts.sh
bash "${RUNR_DIR:-.}"/recipes/xfce.sh
bash "${RUNR_DIR:-.}"/installers/setupchrome.sh
bash "${RUNR_DIR:-.}"/installers/setuprdp.sh xfce

# System
bash "${RUNR_DIR:-.}"/recipes/fix.sh

# Devel
bash "${RUNR_DIR:-.}"/recipes/dev-stacks.sh
bash "${RUNR_DIR:-.}"/recipes/dev-tools.sh
bash "${RUNR_DIR:-.}"/recipes/dev-fonts.sh
