#!/usr/bin/env bash

echo
echo "==> Setting up setupbox.sh (packages, shell, DEV dir)..."

SCRIPT_DIR="${0%/*}"
SCRIPT_DIR="${SCRIPT_DIR:-$(pwd)}"

# #############################################################################
# Globals

INSTALL_DEB_SEL="$SCRIPT_DIR/custom/debselects.sh"
INSTALL_RPM_SEL="$SCRIPT_DIR/custom/rpmselects.sh"
MASTER_URL=https://raw.githubusercontent.com/stroparo/dotfiles/master
SETUP_URL=$MASTER_URL/setupshell.sh

if which curl >/dev/null 2>&1 ; then
  export DLPROG=curl
  export DLOPT='-LSfs'
elif which wget >/dev/null 2>&1 ; then
  export DLPROG=wget
  export DLOPT='-O -'
else
  echo "FATAL: curl and wget missing" 1>&2
  exit 1
fi

# #############################################################################

"${INSTALL_DEB_SEL}"
test -f "${INSTALL_DEB_SEL}" \
  || bash -c "$(${DLPROG} ${DLOPT} "${MASTER_URL}/custom/debselects.sh")"

"${INSTALL_RPM_SEL}"
test -f "${INSTALL_RPM_SEL}" \
  || bash -c "$(${DLPROG} ${DLOPT} "${MASTER_URL}/custom/rpmselects.sh")"

./setupshell.sh
test -f ./setupshell.sh \
  || bash -c "$(${DLPROG} ${DLOPT} "${SETUP_URL}")"

echo "Making the DEV directory..."
export DEV="$HOME"/workspace
mkdir -p "${DEV}"
ls -d -l "${DEV}"
