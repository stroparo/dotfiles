#!/usr/bin/env bash

PROGNAME="conf-intellij.sh"

echo "$PROGNAME: INFO: Intellij custom config started"

# #############################################################################
# Globals

SRC_CONFIG_DIR="${RUNR_DIR:-$PWD}/config/intellij"

# #############################################################################
# Prep User PATH

if (uname -a | egrep -i -q "cygwin|mingw|msys|win32|windows") ; then
  INTELLIJ_USER_DIR="$(cygpath "${USERPROFILE}")/.IntelliJIdea"
elif [[ "$(uname -a)" = *[Ll]inux* ]] ; then
  # TODO review
  INTELLIJ_USER_DIR="${HOME}/.config/intellij"
fi

# #############################################################################
# Deploy

echo "cp -f -R \"${SRC_CONFIG_DIR}\"/* \"${INTELLIJ_USER_DIR}/\" ..."
cp -f -R -v "${SRC_CONFIG_DIR}"/* "${INTELLIJ_USER_DIR}"/

echo "$PROGNAME: COMPLETE"

exit
