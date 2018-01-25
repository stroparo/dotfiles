#!/usr/bin/env bash

# #############################################################################
# Globals

export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf

# #############################################################################
# Check OS

if ! egrep -i -q 'cent ?os|oracle|red ?hat' /etc/*release* ; then
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
# Desktop applications, interactive

echo ${BASH_VERSION:+-e} "\n==> Office? [y/N]\c" ; read answer
[[ $answer = y ]] && sudo $RPMPROG install libreoffice-calc

echo ${BASH_VERSION:+-e} "\n==> Other packages? [y/N]\c" ; read answer
if [[ $answer = y ]] ; then

  PACKAGES="autorenamer
gigolo
gnome-shell-pomodoro
mpv
parole
smplayer
unison unison-gtk
usb-creator-gtk
"

  for package in $(echo $PACKAGES) ; do
    echo ${BASH_VERSION:+-e} "\n==> $RPMPROG install '$package'? [Y/n]\c" ; read answer
    if [[ $answer != n ]] ; then
      sudo $RPMPROG install -y $package
    fi
  done

fi

# #############################################################################
# Silver Searcher Ag
# Source: https://github.com/ggreer/the_silver_searcher

if ! ag --version ; then
  if ! grep -i -q 'fedora' /etc/*release* ; then
    sudo $RPMPROG install -y epel-release.noarch
  fi
  sudo $RPMPROG install -y the_silver_searcher
fi

# #############################################################################
# Cleanup

