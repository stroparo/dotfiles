#!/usr/bin/env bash

# Run this script from its directory otherwise it will not find
#  the ./scripts/ directory and will self provision.

# #############################################################################
# Self provisioning

if [ ! -d ./scripts ] ; then

  curl -LSfs -o "$HOME"/.dotfiles.zip \
    https://github.com/stroparo/dotfiles/archive/master.zip

  unzip -o "$HOME"/.dotfiles.zip -d "$HOME" \
    && (cd "$HOME"/dotfiles-master \
    && [ "$PWD" = "$HOME"/dotfiles-master ] \
    && ./setup.sh "$@") \
    || exit $?

  rm -f -r "$HOME"/dotfiles-master
  exit
fi

# #############################################################################
# Options

: ${DO_ALIASES:=false}
: ${DO_BOX:=false}
: ${DO_DOT:=false}
: ${DO_SHELL:=false}
: ${FULL:=false}
: ${OVERRIDE_SUBL_PREFS:=false}

# Options:
OPTIND=1
while getopts ':abdfs' option ; do
  case "${option}" in
    a) DO_ALIASES=true;;
    b) DO_BOX=true;;
    d) DO_DOT=true;;
    f) FULL=true;;
    s) DO_SHELL=true;;
  esac
done
shift "$((OPTIND-1))"

export OVERRIDE_SUBL_PREFS

# #############################################################################
# Configurations

if ${DO_ALIASES:-false} || ${FULL:-false} ; then
  ./setupaliases.sh
fi

if ${DO_BOX:-false} || ${FULL:-false} ; then
  ./setupbox.sh
fi

if ${DO_SHELL:-false} || ${FULL:-false} ; then
  ./setupshell.sh
fi

if ${DO_DOT:-false} || ${FULL:-false} ; then

  ./scripts/dotify.sh

  for deploy in `ls ./scripts/deploy*sh` ; do
    "$deploy"
  done
fi
