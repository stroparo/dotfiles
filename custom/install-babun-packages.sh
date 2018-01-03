#!/usr/bin/env bash

if [ -e setup-cygwin.bat ] ; then
  pact install `grep CYGPKGS= setup-cygwin.bat | sed -e 's/^SET CYGPKGS=%CYGPKGS%//'`
  exit $?
else
  echo "FATAL: Run in the same dir containing 'setup-cygwin.bat'." 1>&2
  exit 1
fi
