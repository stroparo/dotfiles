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

: ${OVERRIDE_SUBL_PREFS:=false}
: ${DO_BOX:=false}
FULL=false

# Options:
OPTIND=1
while getopts ':bf' option ; do
    case "${option}" in
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

./setupaliases.sh

${DO_BOX:-false} && ./setupbox.sh

./scripts/dotify.sh

for deploy in `ls ./scripts/deploy*sh` ; do
  "$deploy"
done
