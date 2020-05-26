#!/usr/bin/env bash

: ${PROGNAME:=setupdsifmissing.sh}

if [ ! -e "${DS_HOME:-$HOME/.ds}/ds.sh" ] ; then
  "${RUNR_DIR:-.}"/installers/setupds.sh
fi
if [ ! -e "${DS_HOME:-$HOME/.ds}/ds.sh" ] ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: Missing dependency: Daily Shells." 1>&2
  echo
  exit 1
fi

. "${DS_HOME:-$HOME/.ds}/ds.sh"
