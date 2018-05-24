#!/usr/bin/env bash

# Cristian Stroparo's dotfiles

echo
echo "==> Setting up sublime text..."

if ! (which sublime_text || which subl) >/dev/null 2>&1 ; then
  echo "deploysublime: SKIP: sublime text not in the path" 1>&2
  exit
fi

# #############################################################################
# Prep Sublime Text User PATH

SUBL_WIN="$(cygpath "$USERPROFILE")"'/AppData/Roaming/Sublime Text 3'

if uname -a | egrep -i -q 'cygwin|mingw|msys' ; then
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
# Deploy Sublime Text configuration

mkdir -p "${SUBL_USER}"

subl_files="$(ls -1d ./sublime3/*)"

if ! ${OVERRIDE_SUBL_PREFS:-false} \
  && [ -f "${SUBL_USER}/Preferences.sublime-settings" ]
then
  subl_files="$(echo "$subl_files" | grep -F -v Preferences.sublime-settings)"
fi

# Prep for eval: quote, and translate newlines to space separators:
subl_files="$(echo "$subl_files" | sed "s/^/'/" | sed "s/$/'/" | tr '\n' ' ')"

eval cp -L -R -v "${subl_files}" "\"${SUBL_USER}\""/

# #############################################################################
# Symlink subl

if [ ! -e /usr/local/bin/subl ] \
  && which sublime_text >/dev/null 2>&1 \
  && [[ $(which sublime_text) != ${HOME}* ]]
then
  sudo ln -s $(which sublime_text) /usr/local/bin/subl
fi

# #############################################################################
# Windows specific

if [[ "$(uname -a)" = *[Cc]ygwin* ]]; then
  sed -i -e 's/Knack Nerd Font Mono/Knack NF/' \
    "${SUBL_USER}"/Preferences.sublime-settings
fi

# #############################################################################
