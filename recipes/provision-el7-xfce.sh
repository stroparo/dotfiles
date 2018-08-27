#!/usr/bin/env bash

PROG=provision-el7-xfce.sh

_print_header () {
  echo "################################################################################"
  echo "$@"
}

_print_header "Basic tools"
bash "${RUNR_DIR:-.}"/entry.sh -b setupds sshkeygen sshmodes

# Devel
bash "${RUNR_DIR:-.}"/recipes/devel-stacks.sh
bash "${RUNR_DIR:-.}"/recipes/devel-tools.sh

_print_header "Basic system"
bash "${RUNR_DIR:-.}"/recipes/base-el7-gui.sh
bash "${RUNR_DIR:-.}"/recipes/base-el7-gui-fonts.sh
bash "${RUNR_DIR:-.}"/recipes/xfce.sh

_print_header "Applying fixes"
bash "${RUNR_DIR:-.}"/recipes/fix-fedora-input.sh
bash "${RUNR_DIR:-.}"/recipes/fix-guake-python2.sh

_print_header "Applications"
bash "${RUNR_DIR:-.}"/installers/setupchrome.sh
bash "${RUNR_DIR:-.}"/installers/setuprdp.sh xfce
