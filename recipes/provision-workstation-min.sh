#!/usr/bin/env bash

PROG=provision-workstation-min.sh

# #############################################################################
# Helpers

_print_header () {
  echo "################################################################################"
  echo "$@"
  echo "################################################################################"
}

# #############################################################################

_print_header "Basic tools"
bash ./entry.sh -b

_print_header "Basic system"
bash "${DOTFILES_DIR:-.}"/recipes/fonts-for-devel.sh

_print_header "Applying fixes"
bash "${DOTFILES_DIR:-.}"/recipes/fix-fedora-input.sh
bash "${DOTFILES_DIR:-.}"/recipes/fix-guake-python2.sh

_print_header "Applications"
bash "${DOTFILES_DIR:-.}"/installers/setupchrome.sh
bash "${DOTFILES_DIR:-.}"/installers/setuprdp.sh xfce

# #############################################################################
