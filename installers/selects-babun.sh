#!/usr/bin/env bash

# Globals

PROGNAME=selects-babun.sh

CYGWINSETUP=selects-cygwin.bat
if ls "./installers/$CYGWINSETUP" >/dev/null 2>&1 ; then
  CYGWINSETUP="./installers/$CYGWINSETUP"
elif [ ! -e "$CYGWINSETUP" ] ; then
  echo "${PROGNAME:+PROGNAME: }FATAL: Run in the same dir containing '$CYGWINSETUP'." 1>&2
  exit 1
fi

# Requirements

if ! type pact >/dev/null 2>&1 ; then
  echo "${PROGNAME:+PROGNAME: }FATAL: Not in Babun as the pact package installer program is not available.." 1>&2
  exit 1
fi

# Main

pact install `grep "CYGSETUP.*-P" "$CYGWINSETUP" | grep -o -- '-P .*$' | sed -e 's/-P //g' | tr , ' '`
exit $?
