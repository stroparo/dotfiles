#!/usr/bin/env bash

PROGNAME="conf-subl.sh"

echo "$PROGNAME: INFO: SublimeText custom config started"
echo "$PROGNAME: INFO: started"

# #############################################################################
# Globals

SRC_CONFIG_DIR="${RUNR_DIR:-$PWD}/config/subl"

# #############################################################################
# Prep User PATH

if (uname -a | egrep -i -q "cygwin|mingw|msys|win32|windows") ; then

  SUBL_WIN="$(cygpath "${USERPROFILE}")"'/AppData/Roaming/Sublime Text 3'

  if [ -d "${SUBL_WIN}" ] ; then
    SUBL_USER="${SUBL_WIN}/Packages/User"
  fi

  # Prefer an opt dir sublime_text instance instead, if any:
  if [ -d "$(cygpath "${USERPROFILE}")/opt/subl" ] ; then
    SUBL_USER="$(cygpath "${USERPROFILE}")/opt/subl/Data/Packages/User"
  elif [ -d "/c/opt/subl" ] ; then
    SUBL_USER="/c/opt/subl/Data/Packages/User"
  elif [ -d "/cygdrive/c/opt/subl" ] ; then
    SUBL_USER="/cygdrive/c/opt/subl/Data/Packages/User"
  fi
elif [[ "$(uname -a)" = *[Ll]inux* ]] ; then
  SUBL_USER="${HOME}/.config/sublime-text-3/Packages/User"
fi

if [ ! -d "${SUBL_USER}" ] ; then
  echo "${PROGNAME:+$PROGNAME: }SKIP configuration as there is no SUBL_USER dir ('${SUBL_USER}')."
  exit
fi

# #############################################################################
# Deploy

mkdir -p "${SUBL_USER}"

if [ -z "$SRC_CONFIG_DIR" ] ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: No source config dir found ($SRC_CONFIG_DIR)." 1>&2
  exit 1
fi
config_filenames="$(ls -1d "${SRC_CONFIG_DIR}"/*)"
config_filenames="$(echo "$config_filenames" | sed "s/^/'/" | sed "s/$/'/" | tr '\n' ' ')" # prep for eval

if ! eval cp -v -L -R "${config_filenames}" "\"${SUBL_USER}\""/ ; then
  echo "${PROGNAME:+$PROGNAME: }ERROR deploying sublimetext files." 1>&2
fi

# #############################################################################
# Package Control ignored plugins if not in Linux

if ! (uname -a | grep -i -q linux) ; then
  sed -i -e 's#"Git#// "Git#' "${SUBL_USER}/Package Control.sublime-settings"
fi

# #############################################################################
# Packages no longer maintained, installed from this repo's assets dir

if [ -d "${SUBL_USER}/../../Installed Packages" ] ; then
  if ! cp -v -L -R "${RUNR_DIR:-$PWD}/assets/subl-Installed-Packages"/* "${SUBL_USER}/../../Installed Packages"/ ; then
    echo "${PROGNAME:+$PROGNAME: }ERROR deploying local 'Installed Packages'." 1>&2
  fi
else
  echo "${PROGNAME:+$PROGNAME: }SKIP: deployment of local 'Installed Packages' as there is no '${SUBL_USER}/../../Installed Packages' dir."
fi

# #############################################################################
# Symlink for any existing portable instance

if (uname -a | grep -i -q linux) \
  && [ ! -e /usr/local/bin/subl ] \
  && which sublime_text >/dev/null 2>&1 \
  && [[ $(which sublime_text) != ${HOME}* ]]
then
  sudo ln -s $(which sublime_text) /usr/local/bin/subl
fi

echo "$PROGNAME: COMPLETE"
exit
