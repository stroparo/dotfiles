#!/usr/bin/env bash

# Daily Shells Extras extensions
# More instructions and licensing at:
# https://github.com/stroparo/ds-extras

echo ${BASH_VERSION:+-e} '\n\n==> Installing subl...' 1>&2

# #############################################################################
# Globals

SUBL_DIR="$HOME/opt"
SUBL_URL_LINUX='https://download.sublimetext.com/sublime_text_3_build_3143_x64.tar.bz2'
SUBL_URL_WINDOWS='https://download.sublimetext.com/Sublime%20Text%20Build%203143%20x64.zip'

# #############################################################################
# Checks

# Check for idempotency
if type subl >/dev/null 2>&1 ; then
  echo "SKIP: Already installed." 1>&2
  exit
fi

# #############################################################################
# Options

# Options:
OPTIND=1
while getopts ':d:' option ; do
  case "${option}" in
    d) SUBL_DIR="${OPTARG}";;
    h) echo "$USAGE"; exit;;
  esac
done
shift "$((OPTIND-1))"

# #############################################################################
# Linux

if egrep -i -q 'linux' /etc/*release* ; then

  mkdir -p "$SUBL_DIR"
  cd "$SUBL_DIR"
  curl -k -L -o ./subl3.tar.bz2 "$SUBL_URL_LINUX"
  sudo tar xjvf ./subl3.tar.bz2
  ln -s -v ./sublime_text_3 ./subl # directory
  ln -s -v sublime_text ./subl/subl # binary

# #############################################################################
# Cygwin

elif [[ "$(uname -a)" = *[Cc]ygwin* ]] ; then

  SUBL_DIR="$(cygpath 'C:\opt')"
  mkdir -p "$SUBL_DIR"
  cd "$SUBL_DIR"
  curl -k -L -o ./subl3.zip "$SUBL_URL_WINDOWS"
  unzip ./subl3.zip

# #############################################################################

else
  echo "FATAL: OS not handled." 1>&2
  exit 1
fi
