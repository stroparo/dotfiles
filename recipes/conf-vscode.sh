#!/usr/bin/env bash

PROGNAME="conf-vscode.sh"

echo
echo "################################################################################"
echo "Configure Visual Studio Code editor; \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Globals

export VSCODE_CMD="code"

# #############################################################################
# Requirements

if ! which ${VSCODE_CMD} >/dev/null 2>&1 ; then
  echo "${PROGNAME:+$PROGNAME: }SKIP: vscode not available." 1>&2
  exit
fi

# #############################################################################
# Set as default editor

if which xdg-mime >/dev/null 2>&1 ; then
  xdg-mime default code.desktop text/plain
fi

if which update-alternatives >/dev/null 2>&1 \
  && egrep -i -q -r 'debian|ubuntu' /etc/*release
then
  sudo update-alternatives --set editor "$(which ${VSCODE_CMD})"
fi

# #############################################################################
# Conf - User settings

if (uname -a | egrep -i -q "cygwin|mingw|msys|win32|windows") ; then
  CODE_USER_DIR="$(cygpath "${USERPROFILE}")/AppData/Roaming/Code/User"
elif [[ "$(uname -a)" = *[Ll]inux* ]] ; then
  CODE_USER_DIR="${HOME}/.config/Code/User"
fi

# Start vscode for it to create the user dir, then kill it right away:
${VSCODE_CMD} >/dev/null 2>&1 &
sleep 8
kill %1

if [ ! -d "${CODE_USER_DIR}" ] ; then
  echo "${PROGNAME:+$PROGNAME: }SKIP assets copy as there is no CODE_USER_DIR dir ('$CODE_USER_DIR')." 1>&2
  exit
fi

assets_dir=$(dirname "$(find "${RUNR_DIR:-$PWD}" -type f -name 'settings.json' | grep 'code')")
if [ -z "$assets_dir" ] ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: No assets dir found ($assets_dir)." 1>&2
  exit 1
fi
assets="$(ls -1d ${assets_dir:-${DEV:-${HOME}/workspace}/dotfiles/config/vscode}/*)"
assets="$(echo "$assets" | sed "s/^/'/" | sed "s/$/'/" | tr '\n' ' ')" # prep for eval

if ! eval cp -L -R "${assets}" "\"${CODE_USER_DIR}\""/ ; then
  echo "${PROGNAME:+$PROGNAME: }ERROR deploying VSCode files." 1>&2
fi

# #############################################################################
# Final sequence

echo "${PROGNAME:+$PROGNAME: }COMPLETE"
echo
