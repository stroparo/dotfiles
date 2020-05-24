#!/usr/bin/env bash

PROGNAME="sshkeygen.sh"
if [[ ${DOTFILES_SUPPRESS} = *${PROGNAME%.*}* ]] ; then exit ; fi

# Create a default SSH key
# Requires Daily Shells at https://stroparo.github.io/ds

echo "$PROGNAME: INFO: SSH key generation; \$0='$0'; \$PWD='$PWD'"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Globals

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
  echo
  exit 1
fi

# #############################################################################
# Main

mkdir ~/.ssh 2>/dev/null
if [ ! -d ~/.ssh ] ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: Could not create ~/.ssh directory." 1>&2
  echo
  exit 1
fi

# Create a key only if there is none loaded:
SSH_ENV="$HOME/.ssh/environment"
if [ -f "$SSH_ENV" ] ; then
  . "$SSH_ENV"
fi
if [ -z "$(ssh-add -l)" ] ; then
  "${DS_HOME:-$HOME/.ds}"/scripts/sshkeygenrsa.sh
else
  echo "${PROGNAME:+$PROGNAME: }SKIP: There already is an active ssh-agent."
  echo
  exit
fi

# #############################################################################
# Final sequence

echo "$PROGNAME: COMPLETE"
exit
