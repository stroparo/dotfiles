#!/usr/bin/env bash

SCRIPT_DIR="${0%/*}"
SCRIPT_DIR="${SCRIPT_DIR:-$(pwd)}"

# #############################################################################
# Globals

INSTALL_APT="$SCRIPT_DIR/custom/install-apt-packages.sh"
INSTALL_PPA="$SCRIPT_DIR/custom/install-ppa-packages.sh"
INSTALL_YUM="$SCRIPT_DIR/custom/install-yum-packages.sh"
MASTER_URL=https://raw.githubusercontent.com/stroparo/dotfiles/master
SETUP_URL=https://raw.githubusercontent.com/stroparo/dotfiles/master/setup.sh

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

# Install custom package selections:
if grep -E -i -q 'debian|ubuntu' /etc/*release* 2>/dev/null ; then
  if [ -f "${INSTALL_APT}" ] ; then
    "${INSTALL_APT}"
  else
    sh -c "$(${DLPROG} ${DLOPT} "${MASTER_URL}/custom/install-apt-packages.sh")"
  fi

fi

# Install PPA packages:
if grep -E -i -q ubuntu /etc/*release* 2>/dev/null ; then
  if [ -f "${INSTALL_PPA}" ] ; then
    "${INSTALL_PPA}"
  else
    sh -c "$(${DLPROG} ${DLOPT} "${MASTER_URL}/custom/install-ppa-packages.sh")"
  fi
fi

# Install YUM packages:
if grep -E -i -q 'centos|oracle|red ?hat' /etc/*release* 2>/dev/null ; then
  if [ -f "${INSTALL_YUM}" ] ; then
    "${INSTALL_YUM}"
  else
    sh -c "$(${DLPROG} ${DLOPT} "${MASTER_URL}/custom/install-yum-packages.sh")"
  fi
fi

# Base dotfiles:
if [ -f ./setup.sh ] ; then
  ./setup.sh
else
  sh -c "$(${DLPROG} ${DLOPT} "${SETUP_URL}")"
fi

# Make the workspace directory:
export DEV=~/workspace
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
