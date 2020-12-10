#!/usr/bin/env bash

PROGNAME="setupbrave.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi

echo "$PROGNAME: INFO: Brave Browser setup started"
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

  sudo "${APTPROG}" install -y apt-transport-https curl

  curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc \
    | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -

  echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" \
    | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

  sudo "${APTPROG}" update
  sudo "${APTPROG}" install -y brave-browser


else
  echo "${PROGNAME:+$PROGNAME: }SKIP: OS not supported" 1>&2
  exit
fi

# #############################################################################
# Final sequence

echo "$PROGNAME: COMPLETE: Brave Browser setup"
exit
