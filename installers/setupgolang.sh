#!/usr/bin/env bash

PROGNAME="setupgolang.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi
if (sudo apt list --installed | grep -q '^golang-any') \
  || (sudo apt list --installed | grep -q '^golang-go') \
  || (sudo yum list installed | grep -q '^golang')
then
  echo "${PROGNAME}: SKIP: already installed."
  exit
fi
if [ ! -f "${DS_HOME:-$HOME/.ds}/ds.sh" ] ; then
  echo "${PROGNAME}: FATAL: Daily Shells must be installed." 1>&2
  exit 1
fi

echo "$PROGNAME: INFO: Go (golang) setup started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Globals

# System installers
export APTPROG=apt-get; which apt >/dev/null 2>&1 && export APTPROG=apt
export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf
export RPMGROUP="yum groupinstall"; which dnf >/dev/null 2>&1 && export RPMGROUP="dnf group install"
export INSTPROG="$APTPROG"; which "$RPMPROG" >/dev/null 2>&1 && export INSTPROG="$RPMPROG"

# #############################################################################
# Install

"${DS_HOME:-$HOME/.ds}/scripts/pkgupdate.sh"

if egrep -i -q -r 'debian' /etc/*release ; then
  sudo "${INSTPROG}" install -y golang-any
if egrep -i -q -r 'ubuntu' /etc/*release ; then
  sudo "${INSTPROG}" install -y golang-go
elif egrep -i -q -r 'centos|fedora|oracle|red *hat' /etc/*release ; then
  sudo "${INSTPROG}" install -y golang
fi

# #############################################################################
# Final sequence

echo "$PROGNAME: COMPLETE: Go (golang) setup"
exit
