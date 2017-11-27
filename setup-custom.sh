#!/usr/bin/env bash

MASTER_URL=https://raw.githubusercontent.com/stroparo/dotfiles/master
SCRIPT_DIR="${0%/*}"
SCRIPT_DIR="${SCRIPT_DIR:-$(pwd)}"
SETUP_URL=https://raw.githubusercontent.com/stroparo/dotfiles/master/setup.sh

! which curl &> /dev/null \
  && echo "FATAL: curl missing" 1>&2 \
  && exit 1

if [ -f ./setup.sh ] ; then
  ./setup.sh
else
  sh -c "$(curl -LSfs "$SETUP_URL")"
fi

# Install custom package selections:
if grep -E -i -q 'debian|ubuntu' /etc/*release* 2>/dev/null ; then

  "$SCRIPT_DIR/custom/install-apt-packages.sh" || sh -c "$(curl -LSfs "$MASTER_URL/custom/install-apt-packages.sh")"

  if grep -E -i -q ubuntu /etc/*release* 2>/dev/null ; then
    "$SCRIPT_DIR/custom/install-ppa-packages.sh" || sh -c "$(curl -LSfs "$MASTER_URL/custom/install-ppa-packages.sh")"
  fi

elif grep -E -i -q 'centos|oracle|red ?hat' /etc/*release* 2>/dev/null ; then

  "$SCRIPT_DIR/custom/install-yum-packages.sh" || sh -c "$(curl -LSfs "$MASTER_URL/custom/install-yum-packages.sh")"
fi

# Make the workspace directory
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
