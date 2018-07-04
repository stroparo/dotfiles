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
bash "${DOTFILES_DIR:-.}"/entry.sh -b

# Devel
bash "${DOTFILES_DIR:-.}"/recipes/devel-fonts.sh

_print_header "Applying fixes"
bash "${DOTFILES_DIR:-.}"/recipes/fix-fedora-input.sh
bash "${DOTFILES_DIR:-.}"/recipes/fix-guake-python2.sh

_print_header "Applications"
bash "${DOTFILES_DIR:-.}"/installers/setuprdp.sh xfce

# #############################################################################
