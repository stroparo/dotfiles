#!/usr/bin/env bash

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

# Install Debian based package selections:
if grep -E -i -q 'debian|ubuntu' /etc/*release* 2>/dev/null ; then
  if [ -f "${INSTALL_DEB_SEL}" ] ; then
    "${INSTALL_DEB_SEL}"
  else
    bash -c "$(${DLPROG} ${DLOPT} "${MASTER_URL}/custom/debselects.sh")"
  fi

fi

# Install Red Hat based package selections:
if grep -E -i -q 'centos|oracle|red ?hat' /etc/*release* 2>/dev/null ; then
  if [ -f "${INSTALL_RPM_SEL}" ] ; then
    "${INSTALL_RPM_SEL}"
  else
    bash -c "$(${DLPROG} ${DLOPT} "${MASTER_URL}/custom/rpmselects.sh")"
  fi
fi

# Base dotfiles:
if [ -f ./setupshell.sh ] ; then
  ./setupshell.sh
else
  bash -c "$(${DLPROG} ${DLOPT} "${SETUP_URL}")"
fi

# Make the workspace directory:
export DEV="$HOME"/workspace
mkdir -p "${DEV}"
ls -d -l "${DEV}"

# Echo repo cloning loop command:
cat <<EOF

# Clone your git repositories by running this sequence:

cd '${DEV}'
while true ; do
  echo "Type repo URL or Ctrl-C to finish: "
  read repo
  git clone "\$repo"
done
EOF
