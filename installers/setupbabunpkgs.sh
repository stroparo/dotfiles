#!/usr/bin/env bash

CYGWINSETUP=setupcygwin.bat

if [ -e $CYGWINSETUP ] ; then
  pact install `grep CYGPKGS= "$CYGWINSETUP" | sed -e 's/^SET CYGPKGS=%CYGPKGS%//'`
  exit $?
else
  echo "FATAL: Run in the same dir containing '$CYGWINSETUP'." 1>&2
  exit 1
fi
