#!/usr/bin/env bash

PROGNAME="linux-fixes.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi

echo "$PROGNAME: INFO: Applying Linux fixes in '${RUNR_DIR:-.}/recipes-linux-fixes'..."

for fix in "${RUNR_DIR:-.}"/recipes-linux-fixes/fix-* ; do
  bash "${fix}"
done

echo "$PROGNAME: COMPLETE: Linux fixes in '${RUNR_DIR:-.}/recipes-linux-fixes'"
exit
