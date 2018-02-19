#!/usr/bin/env bash

# Daily Shells Extras extensions
# More instructions and licensing at:
# https://github.com/stroparo/ds-extras

echo ${BASH_VERSION:+-e} '\n\n==> Installing subl...' 1>&2

# #############################################################################
# Globals

SUBL_DIR="$HOME/opt"
SUBL_URL_LINUX='https://download.sublimetext.com/sublime_text_3_build_3143_x64.tar.bz2'

# #############################################################################
# Checks

# Check for idempotency
if type subl >/dev/null 2>&1 ; then
  echo "SKIP: Already installed." 1>&2
  exit
fi

# #############################################################################
# Linux

if egrep -i -q 'linux' /etc/*release* ; then

  mkdir -p "$SUBL_DIR"
  cd "$SUBL_DIR"
  curl -k -L -o ./subl3.tar.bz2 "$SUBL_URL_LINUX"
  tar xjvf ./subl3.tar.bz2
  ln -s -v ./sublime_text_3 ./subl # directory
  ln -s -v sublime_text ./subl/subl # binary

# #############################################################################
# Cygwin

elif [[ "$(uname -a)" = *[Cc]ygwin* ]] ; then

  :
  # TODO
  # wget 'https://subl.io/download/windows'
  # mv windows sublsetup.exe
  # chmod u+x sublsetup.exe && ./sublsetup.exe && rm -f ./sublsetup.exe

# #############################################################################

else
  echo "FATAL: OS not handled." 1>&2
  exit 1
fi
