#!/usr/bin/env bash

IS_DESKTOP=false

# ##############################################################################
# Debian

if ! egrep -i -q 'debian|ubuntu' /etc/*release* ; then
  echo "FATAL: Only Debian/Ubuntu based distros are allowed to call this script ($0)" 1>&2
  exit 1
fi

# ##############################################################################
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

# ##############################################################################
sudo apt update

# ##############################################################################
# Upgrade

echo ${BASH_VERSION:+-e} "\n==> Upgrade all packages? [y/N]\c" ; read answer
[[ $answer = y ]] && sudo apt upgrade

# ##############################################################################
# Base

echo ${BASH_VERSION:+-e} "\n==> Base packages..."
sudo apt install -y curl less p7zip-full rsync unzip wget zip zsh

# Etc
sudo apt install -y gdebi-core
sudo apt install -y localepurge logrotate net-tools parted secure-delete silversearcher-ag

# ##############################################################################
# Devel

sudo apt install -y exuberant-ctags git tig httpie jq make sqlite3 tmux vim vim-scripts

# ##############################################################################
# Desktop

echo ${BASH_VERSION:+-e} "\n==> Install XFCE? [y/N]\c" ; read answer
[[ $answer = y ]] && sudo apt install xfce4 desktop-base thunar-volman tango-icon-theme xfce4-notifyd xscreensaver light-locker xfce4-volumed tumbler xfwm4-themes

if apt list --installed 2>/dev/null | egrep -q '(dm|xorg|xfce4)/' ; then
  IS_DESKTOP=true
fi

if $IS_DESKTOP ; then
  echo ${BASH_VERSION:+-e} "\n==> Desktop packages..."
  sudo apt install bum evince galculator guake meld mp3splt ristretto ssh-askpass thunar xbacklight xclip
  sudo apt install gnome-themes-standard gnome-themes-ubuntu gtk2-engines-xfce
  sudo apt install xfce4-clipman-plugin xfce4-mount-plugin xfce4-places-plugin xfce4-terminal xfce4-timer-plugin
fi

# ##############################################################################
# Groups of packages, interactive

echo ${BASH_VERSION:+-e} "\n==> Libs? [Y/n]\c" ; read answer
[[ $answer != n ]] && sudo apt install gettext imagemagick libsqlite3-0 libsqlite3-dev zlib1g zlib1g-dev

echo ${BASH_VERSION:+-e} "\n==> Python? [y/N]\c" ; read answer
[[ $answer = y ]] && sudo apt install python-dev python-pip python3-dev python3-pip

echo ${BASH_VERSION:+-e} "\n==> Virtualbox guest additions dependencies? [y/N]\c" ; read answer
[[ $answer = y ]] && sudo apt install build-essential dkms module-assistant

if $IS_DESKTOP ; then
  echo ${BASH_VERSION:+-e} "\n==> Educational? [y/N]\c" ; read answer
  [[ $answer = y ]] && sudo apt install gperiodic gtypist tuxtype

  echo ${BASH_VERSION:+-e} "\n==> Games? [y/N]\c" ; read answer
  [[ $answer = y ]] && sudo apt install dosbox stella visualboyadvance-gtk zsnes chocolate-doom gnome-games gnome-sudoku gnuchess joy2key joystick inputattach openttd openttd-opensfx
fi

# ##############################################################################
# Other packages, interactive

echo ${BASH_VERSION:+-e} "\n==> Other packages? [y/N]\c" ; read answer
if [[ $answer = y ]] ; then

  PACKAGES="autorenamer
gigolo
gnome-shell-pomodoro
lftp
libreoffice-calc
mosh
mpv
parole
p7zip-rar
smplayer
unison unison-gtk
usb-creator-gtk"

  for package in $(echo $PACKAGES) ; do
    echo ${BASH_VERSION:+-e} "\n==> apt install '$package'? [Y/n]\c" ; read answer
    if [[ $answer != n ]] ; then
      sudo apt install -y "$package"
    fi
  done

fi

# ##############################################################################
# Cleanup

sudo apt autoremove
sudo apt clean
