#!/usr/bin/env bash

PROG=provision-pc.sh

# #############################################################################
# Helpers

_print_header () {
  echo "################################################################################"
  echo "$@"
  echo "################################################################################"
}

# #############################################################################

_print_header "Basic tools"
bash "${DOTFILES_DIR:-.}"/entry.sh -b

# Devel
bash "${DOTFILES_DIR:-.}"/recipes/devel-stacks.sh
bash "${DOTFILES_DIR:-.}"/recipes/devel-tools.sh

_print_header "Basic system"
bash "${DOTFILES_DIR:-.}"/recipes/xfce.sh

_print_header "Applying fixes"
bash "${DOTFILES_DIR:-.}"/recipes/fix-fedora-input.sh
bash "${DOTFILES_DIR:-.}"/recipes/fix-guake-python2.sh

_print_header "Applications"
bash "${DOTFILES_DIR:-.}"/recipes/apps-debian-desktop.sh
bash "${DOTFILES_DIR:-.}"/recipes/apps-el-desktop.sh
bash "${DOTFILES_DIR:-.}"/recipes/apps-ubuntu-ppa.sh
bash "${DOTFILES_DIR:-.}"/installers/setupanki.sh
bash "${DOTFILES_DIR:-.}"/installers/setupchrome.sh
bash "${DOTFILES_DIR:-.}"/installers/setupdropbox.sh

# #############################################################################
