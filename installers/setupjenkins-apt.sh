#!/usr/bin/env bash

# Daily Shells Extras extensions
# More instructions and licensing at:
# https://github.com/stroparo/ds-extras

echo ${BASH_VERSION:+-e} '\n\n==> Installing jenkins...' 1>&2

# #############################################################################
# Checks

if ! egrep -i -q 'debian|ubuntu' /etc/*release* ; then
  echo "FATAL: Only APT (Debian, Ubuntu etc.) distros supported." 1>&2
  exit 1
fi

# #############################################################################
# Prep

if ! wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key \
  | sudo apt-key add -
then
  echo "FATAL: Error adding key." 1>&2
  exit 1
fi

cat <<EOF | sudo tee -a /etc/apt/sources.list
deb https://pkg.jenkins.io/debian-stable binary/
EOF

if [ "$?" -ne 0 ]; then
  echo "FATAL: Error writing to sources.list" 1>&2
  exit 1
fi

# #############################################################################
# Install

sudo apt update
sudo apt install -y jenkins

# #############################################################################
