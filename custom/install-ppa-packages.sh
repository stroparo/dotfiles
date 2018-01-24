#!/usr/bin/env bash

# #############################################################################
# Helpers

userconfirm () {
    # Info: Ask a question and yield success if user responded [yY]*

    typeset confirm
    typeset result=1

    echo ${BASH_VERSION:+-e} "$@" "[y/N] \c"
    read confirm
    if [[ $confirm = [yY]* ]] ; then return 0 ; fi
    return 1
}

_install_confirm () {
  if userconfirm "Install $1?" ; then
    sudo apt install -y "$@"
  fi
}

_add_ppa_repo () {
  typeset ppa="$1"

  echo ${BASH_VERSION:+-e} "\n==> ls /etc/apt/sources.list.d/${ppa%/*}*.list"

  if ! eval ls -l "/etc/apt/sources.list.d/${ppa%/*}*.list" 2>/dev/null ; then
    sudo add-apt-repository "ppa:$ppa"
  fi
}

# #############################################################################
# Add PPA repos

PPA_REPOS="
hsoft/ppa
font-manager/staging
nextcloud-devs/client
nathan-renniewaldock/qdirstat
remmina-ppa-team/remmina-next
webupd8team/y-ppa-manager
"

for ppa_repo in $PPA_REPOS ; do
  _add_ppa_repo "$ppa_repo"
done

# #############################################################################
# Install packages

sudo apt update
_install_confirm dupeguru-se dupeguru-me dupeguru-pe moneyguru pdfmasher
_install_confirm font-manager
_install_confirm nextcloud-client
_install_confirm qdirstat
_install_confirm remmina \
  remmina-plugin-rdp remmina-plugin-vnc libfreerdp-plugins-standard
_install_confirm y-ppa-manager

# #############################################################################
# Cleanup

sudo apt autoremove
sudo apt clean
