#!/usr/bin/env bash

# #############################################################################
# Globals

export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf

# #############################################################################
# Check OS

if ! egrep -i -q 'cent ?os|fedora|oracle|red ?hat' /etc/*release* ; then
  echo "FATAL: Only Red Hat based distros are supported" 1>&2
  exit 1
fi

# #############################################################################
# Sudo check

if ! which sudo ; then
  echo "FATAL: Please setup sudo for your user first.." 1>&2
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

# #############################################################################
# Fedora 26 & 27

if egrep -i -q 'fedora 2[67]' /etc/*release* ; then

  fedora_version=$(egrep -i -o 'fedora 2[67]' /etc/*release* \
    | head -1 \
	| awk '{ print $2; }')

  # XFCE Whisker Menu:
  sudo $RPMPROG remove xfce4-whiskermenu-plugin
  sudo curl -o /etc/yum.repos.d/home:gottcode.repo \
    "http://download.opensuse.org/repositories/home:\
/gottcode/Fedora_${fedora_version}/home:\
gottcode.repo"
  sudo $RPMPROG install xfce4-whiskermenu-plugin
fi

# #############################################################################

