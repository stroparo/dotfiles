#!/usr/bin/env bash

PROGNAME="apps-ubuntu-ppa.sh"

if ! egrep -i -q -r 'ubuntu' /etc/*release ; then echo "PROGNAME: SKIP: Ubuntu supported only" ; exit ; fi

echo "$PROGNAME: INFO: Ubuntu PPA selects"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Globals

# System installers
export APTPROG=apt-get; which apt >/dev/null 2>&1 && export APTPROG=apt

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
    echo "$PROGNAME: INFO: Installing '$package'..."
    if ! sudo ${APTPROG} install -y "$package" >/tmp/pkg-install-${package}.log 2>&1 ; then
      echo "${PROGNAME:+$PROGNAME: }WARN: There was an error installing package '$package' - see '/tmp/pkg-install-${package}.log'." 1>&2
    fi
  done
}


# #############################################################################
# Main

# TODO parameterize list of apps to be installed

dpkg -s nextcloud-client || _add_ppa_repo 'nextcloud-devs/client'
dpkg -s qdirstat      || _add_ppa_repo 'nathan-renniewaldock/qdirstat'
dpkg -s stacer        || _add_ppa_repo 'oguzhaninan/stacer'
dpkg -s woeusb        || _add_ppa_repo 'nilarimogard/webupd8'
dpkg -s y-ppa-manager || _add_ppa_repo 'webupd8team/y-ppa-manager'
dpkg -s zeal          || _add_ppa_repo 'zeal-developers/ppa'

sudo ${APTPROG} update

_install_packages \
  nextcloud-client \
  qdirstat \
  stacer \
  woeusb \
  y-ppa-manager \
  zeal

exit
