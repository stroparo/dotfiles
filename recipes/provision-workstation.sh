#!/usr/bin/env bash

PROG=provision-workstation.sh

# #############################################################################
# Helpers

_print_header () {
  echo "################################################################################"
  echo "$@"
  echo "################################################################################"
}

# #############################################################################

_print_header "Basic tools"
bash "${DOTFILES_DIR:-.}"/entry.sh -b setupds sshkeygen

# Devel
bash "${DOTFILES_DIR:-.}"/recipes/devel-stacks.sh
bash "${DOTFILES_DIR:-.}"/recipes/devel-tools.sh

_print_header "Basic system"
bash "${DOTFILES_DIR:-.}"/recipes/base-el7-gui.sh
bash "${DOTFILES_DIR:-.}"/recipes/base-el7-gui-fonts.sh
bash "${DOTFILES_DIR:-.}"/recipes/xfce.sh

_print_header "Applying fixes"
bash "${DOTFILES_DIR:-.}"/recipes/fix-fedora-input.sh
bash "${DOTFILES_DIR:-.}"/recipes/fix-guake-python2.sh

_print_header "Applications"
bash "${DOTFILES_DIR:-.}"/installers/setupchrome.sh
bash "${DOTFILES_DIR:-.}"/installers/setuprdp.sh xfce

# #############################################################################
