#!/usr/bin/env bash

PROGNAME="setupeditorconfig.sh"

echo
echo "################################################################################"
echo "Setup Editor Config; \$0='$0'; \$PWD='$PWD'"

if (sudo apt list --installed | grep -q '^editorconfig') \
  || (sudo yum list installed | grep -q '^editorconfig')
then
  echo "${PROGNAME:+$PROGNAME: }SKIP: already installed." 1>&2
  exit
fi

if [ ! -f "${DS_HOME:-$HOME/.ds}/scripts/pkgupdate.sh" ] ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: Daily Shells must be installed." 1>&2
  exit 1
fi

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
sudo ${INSTPROG} install -y editorconfig

# #############################################################################
# Final sequence

echo "${PROGNAME:+$PROGNAME: }COMPLETE"
echo
