#!/usr/bin/env bash

# #############################################################################
# Globals

export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf

# #############################################################################
# Check OS

if ! egrep -i -q 'cent ?os|fedora|oracle|red ?hat' /etc/*release* ; then
  echo "FATAL: Only Red Hat based distros are allowed to call this script ($0)" 1>&2
  exit 1
fi

# #############################################################################
# Sudo check

if ! which sudo ; then
  echo "FATAL: Please log in as root, install and then configure sudo for your user first.." 1>&2
  cat "Suggested commands:" <<EOF
su -
$RPMPROG install sudo
visudo
EOF
  exit 1
fi

# #############################################################################
# Upgrade

echo ${BASH_VERSION:+-e} "\n==> Upgrade all packages? [y/N]\c" ; read answer
[[ $answer = y ]] && sudo $RPMPROG update

# #############################################################################
# Install

sudo $RPMPROG install gigolo guake meld parole
sudo $RPMPROG install libreoffice-calc
sudo $RPMPROG install xfce4-whiskermenu-plugin

