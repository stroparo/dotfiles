#!/usr/bin/env bash

PROGNAME=sublime.sh

echo
echo "################################################################################"
echo "Sublime Text setup; \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Prep User PATH

if (uname -a | egrep -i -q "cygwin|mingw|msys|win32|windows") ; then
  SUBL_WIN="$(cygpath "$USERPROFILE")"'/AppData/Roaming/Sublime Text 3'
  if [ -d "${SUBL_WIN}" ] ; then
    SUBL_USER="${SUBL_WIN}/Packages/User"
  elif [ -d "$(cygpath "$USERPROFILE")/opt/subl" ] ; then
    SUBL_USER="$(cygpath "$USERPROFILE")/opt/subl/Data/Packages/User"
  elif [ -d "/c/opt/subl" ] ; then
    SUBL_USER="/c/opt/subl/Data/Packages/User"
  elif [ -d "/cygdrive/c/opt/subl" ] ; then
    SUBL_USER="/cygdrive/c/opt/subl/Data/Packages/User"
  else
    echo "Sublime path:"
    read SUBL_PATH
    SUBL_USER="${SUBL_PATH}/Data/Packages/User"
  fi
elif [[ "$(uname -a)" = *[Ll]inux* ]] ; then
  SUBL_USER="$HOME/.config/sublime-text-3/Packages/User"
fi

if [ ! -d "$SUBL_USER" ] ; then
  echo "${PROGNAME:+$PROGNAME: }SKIP: No SUBL_USER dir ('$SUBL_USER')." 1>&2
  exit
fi

# #############################################################################
# Deploy

mkdir -p "${SUBL_USER}"
assets_dir=$(dirname "$(find "$PWD" -type f -name 'Preferences.sublime-settings')")
if [ -z "$assets_dir" ] ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: No sublimetext conf files dir found." 1>&2
  exit 1
fi
assets="$(ls -1d ${assets_dir:-.}/*)"
assets="$(echo "$assets" | sed "s/^/'/" | sed "s/$/'/" | tr '\n' ' ')" # prep for eval
if ! eval cp -L -R "${assets}" "\"${SUBL_USER}\""/ ; then
  echo "${PROGNAME:+$PROGNAME: }ERROR deploying sublimetext files." 1>&2
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

echo "${PROGNAME:+$PROGNAME: }COMPLETE"
echo
