#!/usr/bin/env bash

PROGNAME="setuplua.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi

echo "$PROGNAME: INFO: Lua platform setup started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Globals

export PROGNAME=setuplua.sh

# System installers
export APTPROG=apt-get; which apt >/dev/null 2>&1 && export APTPROG=apt
export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf
export RPMGROUP="yum groupinstall"; which dnf >/dev/null 2>&1 && export RPMGROUP="dnf group install"

# #############################################################################
# Main

if egrep -i -q -r 'debian|ubuntu' /etc/*release ; then
  sudo $APTPROG install -y liblua5.1-dev luajit libluajit-5.1
elif egrep -i -q -r 'centos|fedora|oracle|red *hat' /etc/*release ; then
  echo "${PROGNAME}: SKIP: TODO implement Lua for Enterprise Linux distributions..." 1>&2
  exit
fi

# #############################################################################
# Final sequence

echo "$PROGNAME: COMPLETE: Lua platform setup"
exit
