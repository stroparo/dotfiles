#!/usr/bin/env bash

PROGNAME="setupvscode.sh"

echo
echo "################################################################################"
echo "Setup Visual Studio Code editor; \$0='$0'; \$PWD='$PWD'"

if which ${VSCODE_CMD:-code} >/dev/null 2>&1 ; then
  echo "${PROGNAME:+$PROGNAME: }SKIP: already installed." 1>&2
  exit
fi

# #############################################################################
# Globals

export VSCODE_CMD="code"

# System installers
export APTPROG=apt-get; which apt >/dev/null 2>&1 && export APTPROG=apt
export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf
export RPMGROUP="yum groupinstall"; which dnf >/dev/null 2>&1 && export RPMGROUP="dnf group install"
export INSTPROG="$APTPROG"; which "$RPMPROG" >/dev/null 2>&1 && export INSTPROG="$RPMPROG"

# #############################################################################
# Install

if egrep -i -q -r 'debian|ubuntu' /etc/*release ; then
  # Add repo
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
  sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
  sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

  # Install
  sudo $INSTPROG update
  sudo $INSTPROG install -y apt-transport-https
  sudo $INSTPROG install -y code # or code-insiders

elif egrep -i -q -r 'centos|fedora|oracle|red *hat' /etc/*release ; then
  # Add repo
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

  # Install
  if egrep -i -q -r 'fedora' /etc/*release ; then
    sudo dnf check-update
    sudo dnf install code
  else
    sudo yum check-update
    sudo yum install code
  fi
fi

# #############################################################################
# Final sequence

echo "${PROGNAME:+$PROGNAME: }COMPLETE"
echo
