#!/usr/bin/env bash

# #############################################################################
# Globals

APTPROG=apt-get ; if which apt >/dev/null 2>&1; then APTPROG=apt ; fi

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
# Desktop applications

echo ${BASH_VERSION:+-e} "\n==> XFCE..."
sudo $APTPROG install xfce4 desktop-base thunar-volman tango-icon-theme xfce4-notifyd xscreensaver light-locker xfce4-volumed tumbler xfwm4-themes

echo ${BASH_VERSION:+-e} "\n==> Desktop packages..."
sudo $APTPROG install bum evince galculator gnome-shell-pomodoro guake meld mp3splt ristretto ssh-askpass thunar xbacklight xclip
sudo $APTPROG install gnome-themes-standard gnome-themes-ubuntu gtk2-engines-xfce
sudo $APTPROG install xfce4-clipman-plugin xfce4-mount-plugin xfce4-places-plugin xfce4-terminal xfce4-timer-plugin

# #############################################################################
# Desktop applications, interactive

echo ${BASH_VERSION:+-e} "\n==> Educational? [y/N]\c" ; read answer
[[ $answer = y ]] && sudo $APTPROG install gperiodic gtypist tuxtype

echo ${BASH_VERSION:+-e} "\n==> Games? [y/N]\c" ; read answer
[[ $answer = y ]] && sudo $APTPROG install dosbox stella visualboyadvance-gtk zsnes chocolate-doom gnome-games gnome-sudoku gnuchess joy2key joystick inputattach openttd openttd-opensfx

echo ${BASH_VERSION:+-e} "\n==> Networking? [y/N]\c" ; read answer
[[ $answer = y ]] && sudo $APTPROG install gigolo

echo ${BASH_VERSION:+-e} "\n==> Office? [y/N]\c" ; read answer
[[ $answer = y ]] && sudo $APTPROG install libreoffice-calc

echo ${BASH_VERSION:+-e} "\n==> Other packages? [y/N]\c" ; read answer
if [[ $answer = y ]] ; then

  PACKAGES="autorenamer
mpv
parole
p7zip-rar
smplayer
unison unison-gtk
usb-creator-gtk"

  for package in $(echo $PACKAGES) ; do
    echo ${BASH_VERSION:+-e} "\n==> $APTPROG install '$package'? [Y/n]\c" ; read answer
    if [[ $answer != n ]] ; then
      sudo $APTPROG install -y "$package"
    fi
  done

fi

# #############################################################################
# Cleanup

sudo $APTPROG autoremove
sudo $APTPROG clean
