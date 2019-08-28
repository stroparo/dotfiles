#!/usr/bin/env bash

PROGNAME="setupnextcloud.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi
if ! egrep -i -q -r 'ubuntu' /etc/*release ; then ; echo "PROGNAME: SKIP: Ubuntu supported only" ; exit ; fi

echo "$PROGNAME: INFO: Next Cloud setup started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Helpers


_add_ppa_repo () {

  typeset ppa="$1"
  if [ -z "$ppa" ] ; then return ; fi

  echo ${BASH_VERSION:+-e} "\n==> ls /etc/apt/sources.list.d/${ppa%/*}*.list"

  if ! eval ls -l "/etc/apt/sources.list.d/${ppa%/*}*.list" 2>/dev/null ; then
    sudo add-apt-repository -y "ppa:$ppa"
  fi
}


_install_packages () {
  for package in "$@" ; do
    echo "Installing '$package'..."
    if ! sudo $INSTPROG install -y "$package" >/tmp/pkg-install-${package}.log 2>&1 ; then
      echo "${PROGNAME:+$PROGNAME: }WARN: There was an error installing package '$package' - see '/tmp/pkg-install-${package}.log'." 1>&2
    fi
  done
}


# #############################################################################
# Main

dpkg -s nextcloud-client  || _add_ppa_repo 'nextcloud-devs/client'
sudo apt update
_install_packages nextcloud-client

# #############################################################################
# Final sequence

echo "$PROGNAME: COMPLETE: Next Cloud setup"
exit
