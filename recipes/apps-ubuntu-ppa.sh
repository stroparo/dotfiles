#!/usr/bin/env bash

PROGNAME=apps-ubuntu-ppa.sh

# #############################################################################
# Early checks

if ! egrep -i -q 'ubuntu' /etc/*release ; then
  echo "${PROGNAME:+$PROGNAME: }SKIP: This is not an Ubuntu distribution." 1>&2
  exit
fi

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

echo "################################################################################"
echo "Ubuntu PPA applications"
echo "################################################################################"

# TODO parameterize list of apps to be installed

dpkg -s qdirstat      || _add_ppa_repo 'nathan-renniewaldock/qdirstat'
dpkg -s woeusb        || _add_ppa_repo 'nilarimogard/webupd8'
dpkg -s y-ppa-manager || _add_ppa_repo 'webupd8team/y-ppa-manager'

sudo apt update

_install_packages qdirstat woeusb y-ppa-manager
