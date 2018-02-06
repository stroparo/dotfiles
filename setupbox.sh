#!/usr/bin/env bash

# Cristian Stroparo's dotfiles - https://github.com/stroparo/dotfiles

echo
echo "==> Setting up setupbox.sh (packages, shell, DEV dir)..."

# #############################################################################
# Globals

SCRIPT_DIR="$(dirname "${0%/*}")"
SCRIPT_DIR="${SCRIPT_DIR:-$(pwd)}"

INSTALL_DEB_SEL="$SCRIPT_DIR/installers/debselects.sh"
INSTALL_RPM_SEL="$SCRIPT_DIR/installers/rpmselects.sh"

# #############################################################################

"${INSTALL_DEB_SEL}"
"${INSTALL_RPM_SEL}"
