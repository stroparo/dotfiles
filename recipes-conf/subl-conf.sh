#!/usr/bin/env bash

PROGNAME="subl-conf.sh"
_exit () { echo "$1" ; echo ; echo ; exit 0 ; }
_exiterr () { echo "$2" 1>&2 ; echo 1>&2 ; echo 1>&2 ; exit "$1" ; }

SRC_CONFIG_DIR="${RUNR_DIR:-$PWD}/config/subl"
if [ ! -d "$SRC_CONFIG_DIR" ] ; then _exiterr 1 "${PROGNAME}: FATAL: No dir '${SRC_CONFIG_DIR}'." ; fi

export EDITOR_COMMAND="subl"
if ! which ${EDITOR_COMMAND} >/dev/null 2>&1 ; then _exit "${PROGNAME}: SKIP: ${EDITOR_COMMAND} not available." ; fi

# Global SUBL_USER:
SUBL_USER="$HOME/.config/sublime-text-3/Packages/User"
SUBL_WIN="$(cygpath "$USERPROFILE" 2>/dev/null)/AppData/Roaming/Sublime Text 3"
SUBL_WIN_OPT="$(cygpath "$MYOPT" 2>/dev/null)/subl"
SUBL_WIN_OPT_USER="$(cygpath "$USERPROFILE" 2>/dev/null)/opt/subl"
if [ -d "${SUBL_WIN}" ] ; then SUBL_USER="${SUBL_WIN}/Packages/User" ; fi
if [ -d "${SUBL_WIN_OPT}" ] ; then SUBL_USER="${SUBL_WIN_OPT}/Data/Packages/User" ; fi
if [ -d "${SUBL_WIN_OPT_USER}" ] ; then SUBL_USER="${SUBL_WIN_OPT_USER}/Data/Packages/User" ; fi
mkdir -p "${SUBL_USER}"
if [ ! -d "$SUBL_USER" ] ; then _exiterr 1 "${PROGNAME}: FATAL: Could not create SUBL_USER dir '$SUBL_USER'." ; fi


echo "$PROGNAME: INFO: SublimeText custom config started..."


# Copy config files:
config_filenames="$(ls -1d "${SRC_CONFIG_DIR}"/*)"
config_filenames="$(echo "$config_filenames" | sed "s/^/'/" | sed "s/$/'/" | tr '\n' ' ')" # prep for eval
if ! eval cp -v -L -R "${config_filenames}" "\"${SUBL_USER}\""/ ; then
  echo "${PROGNAME:+$PROGNAME: }ERROR: deploying sublimetext files." 1>&2
fi

# Package Control ignored plugins if not in Linux
if ! (uname -a | grep -i -q linux) ; then
  sed -i -e 's#"Git#// "Git#' "${SUBL_USER}/Package Control.sublime-settings"
fi

# Packages no longer online, installed from this repo's assets dir
if [ -d "${RUNR_DIR:-$PWD}/assets/subl-packages" ] && [ -d "${SUBL_USER}/../../Installed Packages" ] ; then
  if ! cp -v -L -R "${RUNR_DIR:-$PWD}/assets/subl-packages"/* "${SUBL_USER}/../../Installed Packages"/ ; then
    echo "${PROGNAME:+$PROGNAME: }ERROR: deploying local 'Installed Packages'." 1>&2
  fi
  if which subl-conf-custom.sh >/dev/null 2>&1 ; then
    SUBL_USER="${SUBL_USER}" subl-conf-custom.sh
  fi
fi

# Symlink for any existing instance not in HOME:
if which sublime_text >/dev/null 2>&1 && [[ $(which sublime_text) != ${HOME}* ]] ; then
  sudo ln -s $(which sublime_text) /usr/local/bin/subl
fi

_exit "$PROGNAME: COMPLETE"
