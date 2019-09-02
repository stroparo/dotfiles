#!/usr/bin/env bash

PROGNAME="linux-fixes.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi

echo "$PROGNAME: INFO: started >>>> this is a compound recipe"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################

echo "$PROGNAME: INFO: executing '${RUNR_DIR:-.}/recipes-linux-fixes/fix-*'..."

for fix in "${RUNR_DIR:-.}"/recipes-linux-fixes/fix-* ; do
  bash "${fix}"
done

echo "$PROGNAME: COMPLETE: '${RUNR_DIR:-.}/recipes-linux-fixes' (compound)"
exit
