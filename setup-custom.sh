#!/usr/bin/env bash

INSTALL_APT="$SCRIPT_DIR/custom/install-apt-packages.sh"
INSTALL_PPA="$SCRIPT_DIR/custom/install-ppa-packages.sh"
INSTALL_YUM="$SCRIPT_DIR/custom/install-yum-packages.sh"
MASTER_URL=https://raw.githubusercontent.com/stroparo/dotfiles/master
SCRIPT_DIR="${0%/*}"
SCRIPT_DIR="${SCRIPT_DIR:-$(pwd)}"
SETUP_URL=https://raw.githubusercontent.com/stroparo/dotfiles/master/setup.sh

! which curl &> /dev/null \
  && echo "FATAL: curl missing" 1>&2 \
  && exit 1

# Install custom package selections:
if grep -E -i -q 'debian|ubuntu' /etc/*release* 2>/dev/null ; then
  if [ -f "$INSTALL_APT" ] ; then
    "$INSTALL_APT"
  else
    sh -c "$(curl -Lf "$MASTER_URL/custom/install-apt-packages.sh")"
  fi

fi

# Install PPA packages:
if grep -E -i -q ubuntu /etc/*release* 2>/dev/null ; then
  if [ -f "$INSTALL_PPA" ] ; then
    "$INSTALL_PPA"
  else
    sh -c "$(curl -Lf "$MASTER_URL/custom/install-ppa-packages.sh")"
  fi
fi

# Install YUM packages:
if grep -E -i -q 'centos|oracle|red ?hat' /etc/*release* 2>/dev/null ; then
  if [ -f "$INSTALL_YUM" ] ; then
    "$INSTALL_YUM"
  else
    sh -c "$(curl -Lf "$MASTER_URL/custom/install-yum-packages.sh")"
  fi
fi

# Base dotfiles:
if [ -f ./setup.sh ] ; then
  ./setup.sh
else
  sh -c "$(curl -LSfs "$SETUP_URL")"
fi

# Make the workspace directory:
export DEV=~/workspace
mkdir -p "$DEV"
ls -d -l "$DEV"

# Echo repo cloning loop command:
cat <<EOF

# Clone your git repositories by running this sequence:

cd '$DEV'
while true ; do
  echo "Type repo URL or Ctrl-C to finish: "
  read repo
  git clone "\$repo"
done
EOF
