#!/usr/bin/env bash

# Create a default SSH key

PROGNAME="sshkeygen.sh"
if [[ ${DOTFILES_SUPPRESS} = *${PROGNAME%.*}* ]] ; then exit ; fi
SCRIPT_DIR="$(dirname "${0%/*}")"
SCRIPT_DIR="${SCRIPT_DIR:-$(pwd)}"

echo "$PROGNAME: INFO: SSH key generation; \$0='$0'; \$PWD='$PWD'"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

source "${RUNR_DIR:-.}"/helpers/dsenforce.sh


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
  "${DS_HOME:-$HOME/.ds}"/scripts/sshkeygenecdsa.sh
else
  echo "${PROGNAME:+$PROGNAME: }SKIP: There already is an active ssh-agent."
  echo
  exit
fi

echo "$PROGNAME: COMPLETE"
echo
echo

exit
