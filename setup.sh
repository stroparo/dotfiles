#!/usr/bin/env bash

# #############################################################################
# Options

export OVERRIDE_SUBL_PREFS=false

if [ "$1" = '-f' ] ; then
  export OVERRIDE_SUBL_PREFS=true
  shift
fi

# #############################################################################
# Configurations

./scripts/dotify.sh || exit $?

for deploy in `ls ./scripts/deploy*sh` ; do
  "$deploy" || exit $?
done
