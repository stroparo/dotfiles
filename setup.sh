#!/usr/bin/env bash

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

export OVERRIDE_SUBL_PREFS=false

if [ "$1" = '-f' ] ; then
  export OVERRIDE_SUBL_PREFS=true
  shift
fi

# #############################################################################
# Configurations

./scripts/dotify.sh
./setupaliases.sh
./setupbox.sh

for deploy in `ls ./scripts/deploy*sh` ; do
  "$deploy"
done
