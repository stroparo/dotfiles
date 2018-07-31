#!/usr/bin/env bash

# Create a default SSH key

# #############################################################################
# Globals

PROGNAME=sshkeygen.sh
SCRIPT_DIR="$(dirname "${0%/*}")"
SCRIPT_DIR="${SCRIPT_DIR:-$(pwd)}"

# #############################################################################
# Prep

# Daily Shells dependency
if [ ! -e "${DS_HOME:-$HOME/.ds}/ds.sh" ] ; then
  ./installers/setupds.sh
fi
if [ ! -e "${DS_HOME:-$HOME/.ds}/ds.sh" ] ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: No Daily Shells directory available." 1>&2
  exit 1
fi

# #############################################################################
# Main

mkdir ~/.ssh 2>/dev/null
if [ ! -d ~/.ssh ] ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: Could not create ~/.ssh directory." 1>&2
  exit 1
fi

"${DS_HOME:-$HOME/.ds}"/scripts/sshkeygenrsa.sh

# #############################################################################
# Finish

echo "FINISHED sshkeygen recipe"
echo
