#!/usr/bin/env bash

# Cristian Stroparo's dotfiles - https://github.com/stroparo/dotfiles

# Remark:
# Run this script from its directory otherwise it will not find
#  the ./scripts/ directory and will self provision.

# #############################################################################
# Options

NO_ACTION=true

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
    a) DO_ALIASES=true; NO_ACTION=false;;
    b) DO_BOX=true; NO_ACTION=false;;
    d) DO_DOT=true;;
    f) FULL=true;;
    s) DO_SHELL=true; NO_ACTION=false;;
  esac
done
shift "$((OPTIND-1))"

echo INITIAL_FULL=$FULL
export DO_ALIASES DO_BOX DO_DOT DO_SHELL NO_ACTION FULL OVERRIDE_SUBL_PREFS

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

if ${DO_DOT:-false} || ${FULL:-false} || ${NO_ACTION:-true} ; then
  for deploy in `ls ./scripts/deploy*sh` ; do
    "$deploy"
  done

  # Cygwin
  if (uname -a | grep -i -q cygwin) ; then
    GITCONFIG_CYGWIN="$(cygpath "$USERPROFILE")/.gitconfig"
    touch "$GITCONFIG_CYGWIN"
    ./scripts/deploygit.sh "$GITCONFIG_CYGWIN"
  fi
fi

