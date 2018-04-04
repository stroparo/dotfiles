#!/usr/bin/env bash

# Cristian Stroparo's dotfiles - https://github.com/stroparo/dotfiles

# #############################################################################
# Globals

if [ -z "$INSTPROG" ] ; then
  export INSTPROG=apt-get
  which apt >/dev/null 2>&1 && export INSTPROG=apt
fi

# #############################################################################
# Check OS

if ! egrep -i -q 'debian|ubuntu' /etc/*release ; then
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

sudo $INSTPROG update

echo ${BASH_VERSION:+-e} "\n==> Upgrade all packages? [y/N]\c" ; read answer
[[ $answer = y ]] && sudo $INSTPROG upgrade -y

# #############################################################################
# Main

echo ${BASH_VERSION:+-e} "\n==> Base desktop packages..."
sudo $INSTPROG install -y bum ssh-askpass xbacklight xclip
sudo $INSTPROG install -y gnome-themes-standard
sudo $INSTPROG install -y gnome-themes-ubuntu gtk2-engines-xfce

echo ${BASH_VERSION:+-e} "\n==> Educational..."
sudo $INSTPROG install -y gperiodic

echo ${BASH_VERSION:+-e} "\n==> Productivity..."
sudo $INSTPROG install -y atril galculator guake meld
sudo $INSTPROG install -y gnome-shell-pomodoro
sudo $INSTPROG install -y shutter # screenshots

echo ${BASH_VERSION:+-e} "\n==> Other packages..."
sudo $INSTPROG install -y autorenamer

# #############################################################################
# Cleanup

sudo $INSTPROG autoremove
sudo $INSTPROG clean

# #############################################################################
echo
echo "==> Suggestions"

cat <<EOF

# Games
sudo $INSTPROG install -y chocolate-doom
sudo $INSTPROG install -y dosbox stella zsnes
sudo $INSTPROG install -y gnome-games gnome-sudoku gnuchess
sudo $INSTPROG install -y joy2key joystick inputattach
sudo $INSTPROG install -y openttd openttd-opengfx openttd-openmsx openttd-opensfx timidity
sudo $INSTPROG install -y visualboyadvance-gtk

# Educational
sudo $INSTPROG install -y gtypist tuxtype

# Multimedia
sudo $INSTPROG install -y audacious audacious-plugins
sudo $INSTPROG install -y mp3splt
sudo $INSTPROG install -y mpv
sudo $INSTPROG install -y parole
sudo $INSTPROG install -y ristretto

# Networking
sudo $INSTPROG install -y gigolo # remote filesystem management

# Productivity
sudo $INSTPROG install -y libreoffice-calc

EOF

# #############################################################################

