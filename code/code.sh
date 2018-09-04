#!/usr/bin/env bash

PROGNAME=code.sh

echo
echo "################################################################################"
echo "Visual Studio Code setup; \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Prep User PATH

if (uname -a | egrep -i -q "cygwin|mingw|msys|win32|windows") ; then
  CODE_USER_DIR="$(cygpath "${USERPROFILE}")/AppData/Roaming/Code/User"
elif [[ "$(uname -a)" = *[Ll]inux* ]] ; then
  CODE_USER_DIR="$HOME/.config/vscode/User"
fi

if [ ! -d "$CODE_USER_DIR" ] ; then
  echo "${PROGNAME:+$PROGNAME: }SKIP: No CODE_USER_DIR dir ('$CODE_USER_DIR')." 1>&2
  exit
fi

# #############################################################################
# Deploy

mkdir -p "${CODE_USER_DIR}"
assets_dir=$(dirname "$(find "$PWD" -type f -name 'settings.json')")
if [ -z "$assets_dir" ] ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: No assets dir found ($assets_dir)." 1>&2
  exit 1
fi
assets="$(ls -1d ${assets_dir:-.}/*)"
assets="$(echo "$assets" | sed "s/^/'/" | sed "s/$/'/" | tr '\n' ' ')" # prep for eval
if ! eval cp -L -R "${assets}" "\"${CODE_USER_DIR}\""/ ; then
  echo "${PROGNAME:+$PROGNAME: }ERROR deploying VSCode files." 1>&2
fi

# #############################################################################
# Symlink for any existing portable instance

if (uname -a | grep -i -q linux) \
  && [ ! -e /usr/local/bin/code ] \
  && which code >/dev/null 2>&1 \
  && [[ $(which code) != ${HOME}* ]]
then
  sudo ln -s $(which code) /usr/local/bin/code
fi

echo "${PROGNAME:+$PROGNAME: }COMPLETE"
echo
