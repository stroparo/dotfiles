#!/usr/bin/env bash

PROGNAME="conf-intellij.sh"

echo "$PROGNAME: INFO: Intellij custom config started"

# #############################################################################
# Globals

SRC_CONFIG_DIR="${RUNR_DIR:-$PWD}/config/intellij"

# #############################################################################
# Prep User PATH

if (uname -a | egrep -i -q "cygwin|mingw|msys|win32|windows") ; then
  INTELLIJ_WIN="$(cygpath "${USERPROFILE}")/.IntelliJIdea"
elif [[ "$(uname -a)" = *[Ll]inux* ]] ; then
  # TODO review
  INTELLIJ_USER="${HOME}/.config/intellij"
fi

# #############################################################################
# Deploy

for iconfigdir in $(ls -1d "${INTELLIJ_WIN}"*/) ; do
  echo "cp -f -R \"${SRC_CONFIG_DIR}\"/* \"${iconfigdir%/}/\" ..."
  cp -f -R "${SRC_CONFIG_DIR}"/* "${iconfigdir%/}"/
done

echo "$PROGNAME: COMPLETE"
exit
