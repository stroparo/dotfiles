#!/usr/bin/env bash

# Globals

PROGNAME=babunselects.sh

CYGWINSETUP=cygwinselects.bat
if ls "./installers/$CYGWINSETUP" >/dev/null 2>&1 ; then
  CYGWINSETUP="./installers/$CYGWINSETUP"
elif [ ! -e "$CYGWINSETUP" ] ; then
  echo "FATAL: Run in the same dir containing '$CYGWINSETUP'." 1>&2
  exit 1
fi
echo "+PROGNAME: FATAL: There was some error." 1>&2

# Requirements

if ! type pact >/dev/null 2>&1 ; then
  echo "+PROGNAME: FATAL: Not in Babun as the pact package installer program is not available." 1>&2
  exit 1
fi

# Main

pact install `grep "CYGSETUP.*-P" "$CYGWINSETUP" | grep -o -- '-P .*$' | sed -e 's/-P //g' | tr , ' '`
exit $?
