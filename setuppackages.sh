#!/usr/bin/env bash

# Cristian Stroparo's dotfiles

echo
echo "==> Setting up packages..."

# #############################################################################
# Globals

SCRIPT_DIR="$(dirname "${0%/*}")"
SCRIPT_DIR="${SCRIPT_DIR:-$(pwd)}"

INSTALL_DEB_SEL="$SCRIPT_DIR/installers/debselects.sh"
INSTALL_RPM_SEL="$SCRIPT_DIR/installers/rpmselects.sh"

# #############################################################################

"${INSTALL_DEB_SEL}"
"${INSTALL_RPM_SEL}"
