#!/usr/bin/env bash

echo
echo "################################################################################"
echo "Setup Perl"

# #############################################################################
# Globals

# System installers
export APTPROG=apt-get; which apt >/dev/null 2>&1 && export APTPROG=apt
export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf
export RPMGROUP="yum groupinstall"; which dnf >/dev/null 2>&1 && export RPMGROUP="dnf group install"

# #############################################################################
# Main

if egrep -i -q -r 'debian|ubuntu' /etc/*release ; then
  sudo $APTPROG install -y perl libperl-dev
elif egrep -i -q -r 'centos|fedora|oracle|red *hat' /etc/*release ; then
  sudo $RPMPROG install -y --enablerepo=epel perl perl-devel perl-ExtUtils-Embed
fi

# #############################################################################
# Finish

echo "FINISHED Perl setup"
echo
