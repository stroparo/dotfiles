#!/usr/bin/env bash

PROGNAME="conf-jetbrains.sh"

echo "$PROGNAME: INFO: setup started..."
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Globals

SRC_CONFIG_DIR="${RUNR_DIR:-$PWD}/config/jetbrains"

# #############################################################################
# Prep User PATH

if (uname -a | egrep -i -q "cygwin|mingw|msys|win32|windows") ; then
  JETBRAINS_USER_DIR="$(cygpath "${USERPROFILE}")/.IntelliJIdea"
elif [[ "$(uname -a)" = *[Ll]inux* ]] ; then
  JETBRAINS_USER_DIR="${HOME}/.config/JetBrains"
fi

# #############################################################################
# Deploy

for options_dir in $(find "${JETBRAINS_USER_DIR}" -type d -name 'options') ; do
  echo "cp -f -R \"${SRC_CONFIG_DIR}\"/* \"${options_dir}/\" ..."
  cp -f -R -v "${SRC_CONFIG_DIR}"/* "${options_dir}"/
done


echo "${PROGNAME:+$PROGNAME: }COMPLETE"
echo
echo

exit
