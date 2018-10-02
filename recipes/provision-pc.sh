#!/usr/bin/env bash

PROG=provision-pc.sh

_print_header () {
  echo "################################################################################"
  echo "$@"
}

_print_header "Basic tools"
bash "${RUNR_DIR:-.}"/entry.sh -p shell apps dotfiles

# Devel
bash "${RUNR_DIR:-.}"/recipes/devel-stacks.sh
bash "${RUNR_DIR:-.}"/recipes/devel-tools.sh

_print_header "Basic system"
bash "${RUNR_DIR:-.}"/recipes/xfce.sh

_print_header "Applying fixes"
bash "${RUNR_DIR:-.}"/recipes/fix-fedora-input.sh
bash "${RUNR_DIR:-.}"/recipes/fix-guake-python2.sh

_print_header "Applications"
bash "${RUNR_DIR:-.}"/recipes/apps-debian-desktop.sh
bash "${RUNR_DIR:-.}"/recipes/apps-el-desktop.sh
bash "${RUNR_DIR:-.}"/recipes/apps-ubuntu-ppa.sh
bash "${RUNR_DIR:-.}"/installers/setupanki.sh
bash "${RUNR_DIR:-.}"/installers/setupchrome.sh
bash "${RUNR_DIR:-.}"/installers/setupdropbox.sh
