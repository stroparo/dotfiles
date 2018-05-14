#!/usr/bin/env bash

CYGWINSETUP=wincyg.bat

if [ -e "$CYGWINSETUP" ] && type pact >/dev/null 2>&1 ; then
  pact install `grep "CYGSETUP.*-P" "$CYGWINSETUP" | grep -o -- '-P .*$' | sed -e 's/-P //g' | tr , ' '`
  exit $?
else
  echo "FATAL: Run in the same dir containing '$CYGWINSETUP'." 1>&2
  exit 1
fi
