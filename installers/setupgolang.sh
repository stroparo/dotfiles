#!/usr/bin/env bash

PROGNAME="setupgolang.sh"

source "${RUNR_DIR:-.}"/helpers/sidraenforce.sh
linuxordie.sh

if (sudo apt list --installed | grep -q '^golang-any') \
  || (sudo apt list --installed | grep -q '^golang-go') \
  || (sudo yum list installed | grep -q '^golang')
then
  echo "${PROGNAME}: SKIP: already installed."
  exit
fi

echo "$PROGNAME: INFO: Go (golang) setup started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Globals

# TODO use globals set by the scripting library:
# System installers
export APTPROG=apt-get; which apt >/dev/null 2>&1 && export APTPROG=apt
export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf
export RPMGROUP="yum groupinstall"; which dnf >/dev/null 2>&1 && export RPMGROUP="dnf group install"
export INSTPROG="$APTPROG"; which "$RPMPROG" >/dev/null 2>&1 && export INSTPROG="$RPMPROG"

# #############################################################################
# Install

"${ZDRA_HOME:-$HOME/.zdra}/scripts/pkgupdate.sh"

if egrep -i -q -r 'ubuntu' /etc/*release ; then
  sudo "${INSTPROG}" install -y golang-go
elif egrep -i -q -r 'debian' /etc/*release ; then
  sudo "${INSTPROG}" install -y golang-any
elif egrep -i -q -r 'cent *os|fedora|oracle|red *hat' /etc/*release ; then
  sudo "${INSTPROG}" install -y golang
else
  echo "${PROGNAME:+$PROGNAME: }SKIP: this OS is not handled by this script." 1>&2
  exit
fi

# #############################################################################
# Final sequence

echo "$PROGNAME: COMPLETE: Go (golang) setup"
exit
