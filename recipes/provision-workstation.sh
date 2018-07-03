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
bash ./entry.sh -b

_print_header "Basic dev tools"
bash "${DOTFILES_DIR:-.}"/installers/setuppython.sh
bash "${DOTFILES_DIR:-.}"/installers/setuprust.sh
bash "${DOTFILES_DIR:-.}"/installers/setupdocker.sh
bash "${DOTFILES_DIR:-.}"/installers/setupdocker-compose.sh
bash "${DOTFILES_DIR:-.}"/installers/setupexa.sh
bash "${DOTFILES_DIR:-.}"/installers/setupvim.sh python3

_print_header "Basic system"
bash "${DOTFILES_DIR:-.}"/recipes/base-el7-gui.sh
bash "${DOTFILES_DIR:-.}"/recipes/base-el7-gui-fonts.sh
bash "${DOTFILES_DIR:-.}"/recipes/xfce.sh
bash "${DOTFILES_DIR:-.}"/recipes/fonts-for-devel.sh

_print_header "Applying fixes"
bash "${DOTFILES_DIR:-.}"/recipes/fix-fedora-input.sh
bash "${DOTFILES_DIR:-.}"/recipes/fix-guake-python2.sh

_print_header "Applications"
bash "${DOTFILES_DIR:-.}"/installers/setupchrome.sh
bash "${DOTFILES_DIR:-.}"/installers/setuprdp.sh -y

# #############################################################################
