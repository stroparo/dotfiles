#!/usr/bin/env bash

# Cristian Stroparo's dotfiles

# Remark:
# Run this script from its directory otherwise it will not find
#  the ./scripts/ directory and will self provision.

# #############################################################################
# Options

NO_ACTION=true

: ${DO_ALIASES:=false}
: ${DO_PACKAGES:=false}
: ${DO_DOT:=false}
: ${DO_SHELL:=false}
: ${FULL:=false}
: ${OVERRIDE_SUBL_PREFS:=false}

# Options:
OPTIND=1
while getopts ':abdfps' option ; do
  case "${option}" in
    a) DO_ALIASES=true; NO_ACTION=false;;
    b|p) DO_PACKAGES=true; NO_ACTION=false;;
    d) DO_DOT=true;;
    f) FULL=true;;
    s) DO_SHELL=true; NO_ACTION=false;;
  esac
done
shift "$((OPTIND-1))"

export DO_ALIASES DO_PACKAGES DO_DOT DO_SHELL NO_ACTION FULL OVERRIDE_SUBL_PREFS

# #############################################################################
# Self provisioning

if [ ! -d ./scripts ] ; then

  curl -LSfs -o "$HOME"/.dotfiles.zip \
    https://github.com/stroparo/dotfiles/archive/master.zip

  unzip -o "$HOME"/.dotfiles.zip -d "$HOME" \
    && (cd "$HOME"/dotfiles-master \
    && [ "$PWD" = "$HOME"/dotfiles-master ] \
    && ./setupdotfiles.sh "$@") \
    || exit $?

  echo ${BASH_VERSION:+-e} "\n==> dotfiles directory will remain at:"
  ls -d -l "$HOME"/dotfiles-master
  exit
fi

# #############################################################################
# Configurations

if ${DO_ALIASES:-false} || ${FULL:-false} ; then
  ./setupaliases.sh
fi

if ${DO_PACKAGES:-false} || ${FULL:-false} ; then
  ./setuppackages.sh # {deb,rpm}selects etc.
fi

if ${DO_SHELL:-false} || ${FULL:-false} ; then
  ./setupshell.sh
fi

if ${DO_DOT:-false} || ${FULL:-false} || ${NO_ACTION:-true} ; then
  DEPLOY_SCRIPTS="$(ls -1 ./scripts/deploy*sh | grep -v deploypackages)"

  for deploy_script in $DEPLOY_SCRIPTS ; do
    "$deploy_script"
  done
fi

