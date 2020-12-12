#!/usr/bin/env bash

PROGNAME="conf-vscode.sh"
_exit () { echo "$1" ; echo ; echo ; exit 0 ; }
_exiterr () { echo "$2" 1>&2 ; echo 1>&2 ; echo 1>&2 ; exit "$1" ; }

SRC_CONFIG_DIR="${RUNR_DIR:-$PWD}/config/vsc"
if [ ! -d "$SRC_CONFIG_DIR" ] ; then _exiterr 1 "${PROGNAME}: FATAL: No dir '${SRC_CONFIG_DIR}'." ; fi

export EDITOR_COMMAND="code"
if ! which ${EDITOR_COMMAND} >/dev/null 2>&1 ; then _exit "${PROGNAME}: SKIP: ${EDITOR_COMMAND} not available." ; fi

# Global CODE_USER_DIR:
if which cygpath >/dev/null 2>&1 ; then CODE_USER_DIR="$(cygpath "${USERPROFILE}" 2>/dev/null)/AppData/Roaming/VSCode/User" ; fi
if [[ "$(uname -a)" = *[Ll]inux* ]] ; then CODE_USER_DIR="${HOME}/.config/VSCode/User" ; fi
mkdir -p "${CODE_USER_DIR}"
if [ ! -d "${CODE_USER_DIR}" ] ; then _exit "${PROGNAME}: SKIP: no dir '$CODE_USER_DIR'." ; fi


echo "$PROGNAME: INFO: VSCode custom config started..."


# Set as default editor
if which xdg-mime >/dev/null 2>&1 ; then xdg-mime default vscode.desktop text/plain ; fi
if which update-alternatives >/dev/null 2>&1 && egrep -i -q -r 'debian|ubuntu' /etc/*release ; then
  sudo update-alternatives --set editor "$(which ${EDITOR_COMMAND})"
fi

# Copy config files:
config_filenames="$(ls -1d ${SRC_CONFIG_DIR}/*)"
config_filenames="$(echo "$config_filenames" | sed "s/^/'/" | sed "s/$/'/" | tr '\n' ' ')" # prep for eval
if ! eval cp -v -L -R "${config_filenames}" "\"${CODE_USER_DIR}\""/ ; then
  _exiterr 1 "${PROGNAME}: FATAL: deploying VSCode configuration files."
fi

_exit "$PROGNAME: COMPLETE"
