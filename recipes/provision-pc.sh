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

bash "${DOTFILES_DIR:-.}"/entry.sh -f

_print_header "Basic dev tools"
bash "${DOTFILES_DIR:-.}"/installers/setuppython.sh
bash "${DOTFILES_DIR:-.}"/installers/setupdocker.sh
bash "${DOTFILES_DIR:-.}"/installers/setupdocker-compose.sh
bash "${DOTFILES_DIR:-.}"/installers/setupexa.sh
bash "${DOTFILES_DIR:-.}"/installers/setupvim.sh python3

_print_header "Basic system"
bash "${DOTFILES_DIR:-.}"/recipes/xfce.sh
bash "${DOTFILES_DIR:-.}"/recipes/fonts-for-devel.sh

_print_header "Deploying fixes"
bash "${DOTFILES_DIR:-.}"/recipes/fixfedorainput.sh
bash "${DOTFILES_DIR:-.}"/recipes/fixguake.sh

_print_header "Applications"
bash "${DOTFILES_DIR:-.}"/recipes/apps-debian-desktop.sh
bash "${DOTFILES_DIR:-.}"/recipes/apps-el-desktop.sh
bash "${DOTFILES_DIR:-.}"/recipes/apps-ubuntu-ppa.sh
bash "${DOTFILES_DIR:-.}"/installers/setupanki.sh
bash "${DOTFILES_DIR:-.}"/installers/setupchrome.sh
bash "${DOTFILES_DIR:-.}"/installers/setupdropbox.sh

# #############################################################################
