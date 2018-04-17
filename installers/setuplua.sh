#!/usr/bin/env bash

# Cristian Stroparo's dotfiles

# #############################################################################
# Globals

export PROGNAME=setuplua.sh

# System installers
export APTPROG=apt-get; which apt >/dev/null 2>&1 && export APTPROG=apt
export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf
export RPMGROUP="yum groupinstall"; which dnf >/dev/null 2>&1 && export RPMGROUP="dnf group install"

# #############################################################################
# Main

if egrep -i -q 'debian|ubuntu' /etc/*release ; then
  sudo $APTPROG install -y liblua5.1-dev luajit libluajit-5.1
elif egrep -i -q 'centos|fedora|oracle|red *hat' /etc/*release ; then
  echo "${PROGNAME}: SKIP: TODO implement Lua for Enterprise Linux distributions..." 1>&2
fi

# #############################################################################
