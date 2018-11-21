#!/usr/bin/env bash

PROGNAME=setupzeal.sh
export APTPROG=apt-get; which apt >/dev/null 2>&1 && export APTPROG=apt

echo "################################################################################"
echo "Ubuntu PPA - Zeal offline docs application"
echo "################################################################################"

# #############################################################################
# Early checks

if ! egrep -i -q -r 'ubuntu' /etc/*release ; then
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
    if ! sudo ${APTPROG} install -y "$package" >/tmp/pkg-install-${package}.log 2>&1 ; then
      echo "${PROGNAME:+$PROGNAME: }WARN: There was an error installing package '$package' - see '/tmp/pkg-install-${package}.log'." 1>&2
    fi
  done
}

# #############################################################################
# Main

dpkg -s zeal || _add_ppa_repo 'zeal-developers/ppa'
sudo ${APTPROG} update
_install_packages zeal
