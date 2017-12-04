#!/usr/bin/env bash

# ##############################################################################
# RedHat

if ! egrep -i -q 'cent ?os|oracle|red ?hat' /etc/*release* ; then
  echo "FATAL: Only Red Hat based distros are allowed to call this script ($0)" 1>&2
  exit 1
fi

PROG=yum
if which dnf >/dev/null 2>&1; then
  PROG=dnf
fi

# ##############################################################################
# Sudo check

if ! which sudo ; then
  echo "FATAL: Please log in as root, install and then configure sudo for your user first.." 1>&2
  cat "Suggested commands:" <<EOF
su -
$PROG install sudo
visudo
EOF
  exit 1
fi

# ##############################################################################
# Upgrade

echo ${BASH_VERSION:+-e} "\n==> Upgrade all packages? [y/N]\c" ; read answer
[[ $answer = y ]] && sudo $PROG update

# ##############################################################################
# Desktop applications, interactive

echo ${BASH_VERSION:+-e} "\n==> Office? [y/N]\c" ; read answer
[[ $answer = y ]] && sudo $PROG install libreoffice-calc

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
    echo ${BASH_VERSION:+-e} "\n==> $PROG install '$package'? [Y/n]\c" ; read answer
    if [[ $answer != n ]] ; then
      sudo $PROG install -y $package
    fi
  done

fi

# ##############################################################################
# Silver Searcher Ag
# Source: https://github.com/ggreer/the_silver_searcher

if ! ag --version ; then
  if ! grep -i -q 'fedora' /etc/*release* ; then
    sudo $PROG install -y epel-release.noarch
  fi
  sudo $PROG install -y the_silver_searcher
fi

# ##############################################################################
# Cleanup

