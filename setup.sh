#!/usr/bin/env bash

if ! . ./helpers/setuphelpers.sh ; then
  echo "FATAL: Error while sourcing './helpers.sh'" 1>&2
  exit 1
fi

# #############################################################################
# Options

forcesublprefs=false
if [ "$1" = 'forcesublprefs' ] ; then
  forcesublprefs=true && shift
fi

# #############################################################################
# Headless configs

_exec ./scripts/dotify.sh

# #############################################################################
# GUI envs from this point on...

_is_gui_env || return 0 >/dev/null 2>&1 || exit 0

_exec ./scripts/deploysublime.sh
