#!/usr/bin/env bash

PROGNAME="setupeditorconfig.sh"

source "${RUNR_DIR:-.}"/helpers/sidraenforce.sh
linuxordie.sh

if (sudo apt list --installed | grep -q '^editorconfig') \
  || (sudo yum list installed | grep -q '^editorconfig')
then
  echo "${PROGNAME:+$PROGNAME: }SKIP: already installed." 1>&2
  exit
fi

echo "$PROGNAME: INFO: Editor Config setup started"
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
# Main

if egrep -i -q 'id[^=]*=arch' /etc/*release ; then

  sudo pacman -Sy --noconfirm editorconfig-core-c

elif egrep -i -q 'debian|ubuntu' /etc/*release ; then

  "${ZDRA_HOME:-$HOME/.zdra}/scripts/pkgupdate.sh"
  sudo ${INSTPROG} install -y editorconfig
fi

echo "${PROGNAME:+$PROGNAME: }COMPLETE: Editor Config setup"
