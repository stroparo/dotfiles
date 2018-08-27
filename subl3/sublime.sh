#!/usr/bin/env bash

echo
echo "################################################################################"
echo "Sublime Text setup; \$0='$0'; \$PWD='$PWD'"
if ! (which sublime_text || which subl) >/dev/null 2>&1 ; then exit ; fi

# #############################################################################
# Prep Sublime Text User PATH

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

# #############################################################################
# Deploy

mkdir -p "${SUBL_USER}"
subl_files_dir=$(dirname "$(find "$PWD" -type f -name 'Preferences.sublime-settings')")
if [ -z "$subl_files_dir" ] ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: No sublimetext conf files dir found." 1>&2
  exit 1
fi
subl_files="$(ls -1d ${subl_files_dir:-.}/*)"
subl_files="$(echo "$subl_files" | sed "s/^/'/" | sed "s/$/'/" | tr '\n' ' ')" # prep for eval
if ! eval cp -L -R "${subl_files}" "\"${SUBL_USER}\""/ ; then
  echo "${PROGNAME:+$PROGNAME: }ERROR: Deploying sublimetext files." 1>&2
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

echo "FINISHED sublimetext deployment"
echo
