#!/usr/bin/env bash

PROGNAME="setupskype.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi

echo "$PROGNAME: INFO: Skype setup started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Globals

export APTPROG=apt-get; which apt >/dev/null 2>&1 && export APTPROG=apt
export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf
export RPMGROUP="yum groupinstall"; which dnf >/dev/null 2>&1 && export RPMGROUP="dnf group install"

# #############################################################################
# Main

if egrep -i -q -r '(centos|fedora|oracle|red *hat).* 7' /etc/*release ; then

  # TODO
  :

elif egrep -i -q -r 'debian|ubuntu' /etc/*release ; then

  sudo apt-get install -y <(curl -LSfs https://go.skype.com/skypeforlinux-64.deb)

else
  echo "${PROGNAME:+$PROGNAME: }SKIP: OS not supported" 1>&2
  exit
fi

# #############################################################################
# Final sequence

echo "$PROGNAME: COMPLETE: Skype setup"
exit
