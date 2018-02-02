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
    && ./setup.sh) \
    || exit $?

  rm -f -r "$HOME"/dotfiles-master
  exit
fi

# #############################################################################
# Options

: ${ALIASES_ONLY:=false}
: ${OVERRIDE_SUBL_PREFS:=false}
: ${DO_BOX:=false}
FULL=false

# Options:
OPTIND=1
while getopts ':abf' option ; do
    case "${option}" in
        a) ALIASES_ONLY=true;;
        b) DO_BOX=true;;
        f)
          FULL=true
          OVERRIDE_SUBL_PREFS=true;;
    esac
done
shift "$((OPTIND-1))"

export OVERRIDE_SUBL_PREFS

# #############################################################################
# Configurations

./setupaliases.sh; ${ALIASES_ONLY:-false} && exit

if ${DO_BOX:-false} || ${FULL:-false} ; then
  ./setupbox.sh
fi

./scripts/dotify.sh

for deploy in `ls ./scripts/deploy*sh` ; do
  "$deploy"
done
