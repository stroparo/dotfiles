#!/usr/bin/env bash

PROGNAME="sshmodes.sh"

# Set appropriate modes/permissions to SSH related files

echo "$PROGNAME: INFO: SSH file modes/permissions"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################

mkdir ~/.ssh 2>/dev/null
if [ ! -d ~/.ssh ] ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: Could not create ~/.ssh directory." 1>&2
  exit 1
fi

touch ~/.ssh/authorized_keys
chmod -f -v 600 ~/.ssh/authorized_keys ~/.ssh/id*
chmod -f -v 700 ~/.ssh
ls -l ~/.ssh/authorized_keys ~/.ssh/id*

echo "$PROGNAME: COMPLETE"
exit
