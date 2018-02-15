#!/usr/bin/env bash

# #############################################################################
# Globals

export APTPROG=apt-get; which apt >/dev/null 2>&1 && export APTPROG=apt

# #############################################################################
# Check OS

if ! egrep -i -q 'debian|ubuntu' /etc/*release* ; then
  echo "FATAL: Only Debian/Ubuntu based distros are allowed to call this script ($0)" 1>&2
  exit 1
fi

# #############################################################################
# Sudo check

if ! which sudo ; then
  echo "FATAL: Please log in as root, install and then configure sudo for your user first.." 1>&2
  cat "Suggested commands:" <<EOF
su -
apt update && apt install -y sudo
visudo
EOF
  exit 1
fi

# #############################################################################
# Update

sudo $APTPROG update

echo ${BASH_VERSION:+-e} "\n==> Upgrade all packages? [y/N]\c" ; read answer
[[ $answer = y ]] && sudo $APTPROG upgrade

# #############################################################################
# Main

echo ${BASH_VERSION:+-e} "\n==> Desktop packages..."
sudo $APTPROG install bum ssh-askpass thunar xbacklight xclip
sudo $APTPROG install gnome-themes-standard gnome-themes-ubuntu gtk2-engines-xfce

echo ${BASH_VERSION:+-e} "\n==> Educational..."
sudo $APTPROG install gperiodic gtypist tuxtype

echo ${BASH_VERSION:+-e} "\n==> Games..."
sudo $APTPROG install dosbox stella visualboyadvance-gtk zsnes chocolate-doom gnome-games gnome-sudoku gnuchess joy2key joystick inputattach openttd openttd-opensfx

echo ${BASH_VERSION:+-e} "\n==> Multimedia..."
sudo $APTPROG install mp3splt mpv parole ristretto

echo ${BASH_VERSION:+-e} "\n==> Networking..."
sudo $APTPROG install gigolo
sudo $APTPROG install qbittorrent transmission
sudo $APTPROG install transmission

echo ${BASH_VERSION:+-e} "\n==> Productivity..."
sudo $APTPROG install evince galculator
sudo $APTPROG install gnome-shell-pomodoro
sudo $APTPROG install guake
sudo $APTPROG install libreoffice-calc
sudo $APTPROG install meld

echo ${BASH_VERSION:+-e} "\n==> Other packages..."
sudo $APTPROG install autorenamer

# #############################################################################
# Cleanup

sudo $APTPROG autoremove
sudo $APTPROG clean
