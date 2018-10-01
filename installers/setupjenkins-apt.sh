#!/usr/bin/env bash

PROGNAME=setupjenkins-apt.sh

echo
echo "################################################################################"
echo "Setup Jenkins for Debian based distributions"

# #############################################################################
# Checks

if ! egrep -i -q 'debian|ubuntu' /etc/*release ; then
  echo "${PROGNAME}: SKIP: Only APT (Debian, Ubuntu etc.) Linux distributions supported." 1>&2
  exit
fi

# #############################################################################
# Prep

if ! wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key \
  | sudo apt-key add -
then
  echo "${PROGNAME}: FATAL: Error adding key." 1>&2
  exit 1
fi

if ! sudo grep -i jenkins /etc/apt/sources.list ; then
  cat <<EOF | sudo tee -a /etc/apt/sources.list
deb https://pkg.jenkins.io/debian-stable binary/
EOF
  if [ "$?" -ne 0 ]; then
    echo "${PROGNAME}: FATAL: Error writing to sources.list" 1>&2
    exit 1
  fi
fi

# #############################################################################
# Install

echo "${PROGNAME:+$PROGNAME: }INFO: Updating index..." 1>&2
sudo apt update

echo "${PROGNAME:+$PROGNAME: }INFO: Installing..." 1>&2
sudo apt install -y jenkins

# #############################################################################
# Finish

echo "${PROGNAME}: FINISHED Jenkins for Debian distros setup"
echo
