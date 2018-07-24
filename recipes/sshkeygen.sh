#!/usr/bin/env bash

# Create a default SSH key

# #############################################################################
# Globals

PROGNAME=sshkeygen.sh
SCRIPT_DIR="$(dirname "${0%/*}")"
SCRIPT_DIR="${SCRIPT_DIR:-$(pwd)}"

# #############################################################################
# Prep

if [ ! -e "${DS_HOME:-$HOME/.ds}/ds.sh" ] ; then
  ./installers/setupds.sh
fi
if [ ! -e "${DS_HOME:-$HOME/.ds}/ds.sh" ] ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: No Daily Shells directory available." 1>&2
  exit 1
fi

# #############################################################################
# Main

"${DS_HOME:-$HOME/.ds}"/scripts/sshkeygenrsa.sh

# #############################################################################
