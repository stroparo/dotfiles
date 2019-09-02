#!/usr/bin/env bash

: ${DEV:=${HOME}/workspace} ; export DEV

PROGNAME="workspace.sh"

echo "$PROGNAME: INFO: Provisioning workspace at DEV='${DEV}'..."
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################

if [ -d "$DEV" ] ; then
  echo "$PROGNAME: SKIP: dir DEV='${DEV}' already exists." 1>&2
  exit
else
  mkdir -p "${DEV}"
  echo "DEV dir created:"
  ls -d -l "${DEV}"
fi

echo "$PROGNAME: COMPLETE"
exit
