#!/usr/bin/env bash

PROGNAME="conf-vscodium.sh"

echo "$PROGNAME: INFO: Visual Studio Code custom config started"

# #############################################################################
# Globals

SRC_CONFIG_DIR="${RUNR_DIR:-$PWD}/config/vscodium"
export VSCODE_CMD="codium"

# #############################################################################
# Requirements

if ! which ${VSCODE_CMD} >/dev/null 2>&1 ; then
  echo "${PROGNAME:+$PROGNAME: }SKIP: vscodium not available."
  exit
fi

# #############################################################################
# Set as default editor

if which xdg-mime >/dev/null 2>&1 ; then
  xdg-mime default vscodium.desktop text/plain
fi

if which update-alternatives >/dev/null 2>&1 \
  && egrep -i -q -r 'debian|ubuntu' /etc/*release
then
  sudo update-alternatives --set editor "$(which ${VSCODE_CMD})"
fi

# #############################################################################
# Conf - User settings

if (uname -a | egrep -i -q "cygwin|mingw|msys|win32|windows") ; then
  CODE_USER_DIR="$(cygpath "${USERPROFILE}")/AppData/Roaming/VSCodium/User"
elif [[ "$(uname -a)" = *[Ll]inux* ]] ; then
  CODE_USER_DIR="${HOME}/.config/VSCodium/User"
fi

# Start vscodium for it to create the user dir, then kill it right away:
${VSCODE_CMD} >/dev/null 2>&1 &
sleep 8
kill %1

if [ ! -d "${CODE_USER_DIR}" ] ; then
  echo "${PROGNAME:+$PROGNAME: }SKIP configuration as there is no CODE_USER_DIR dir ('$CODE_USER_DIR')."
  exit
fi

if [ -z "$SRC_CONFIG_DIR" ] ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: No source config dir found ($SRC_CONFIG_DIR)." 1>&2
  exit 1
fi
config_filenames="$(ls -1d ${SRC_CONFIG_DIR}/*)"
config_filenames="$(echo "$config_filenames" | sed "s/^/'/" | sed "s/$/'/" | tr '\n' ' ')" # prep for eval

if ! eval cp -L -R "${config_filenames}" "\"${CODE_USER_DIR}\""/ ; then
  echo "${PROGNAME:+$PROGNAME: }ERROR deploying VSCode configuration files." 1>&2
fi

# #############################################################################
# Final sequence

echo "$PROGNAME: COMPLETE"
exit
