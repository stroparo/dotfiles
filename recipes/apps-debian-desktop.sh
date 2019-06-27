#!/usr/bin/env bash

# Custom Debian package selection for desktop environments

PROGNAME=apps-debian-desktop.sh

# #############################################################################
# Checks

if ! egrep -i -q -r 'debian|ubuntu' /etc/*release ; then
  echo "${PROGNAME:+$PROGNAME: }SKIP: This is not an Debian/Ubuntu Linux family instance." 1>&2
  exit
fi

# #############################################################################
# Globals

# System installers
export APTPROG=apt-get; which apt >/dev/null 2>&1 && export APTPROG=apt
export INSTPROG="$APTPROG"

# #############################################################################
# Helpers

_install_packages () {
  for package in "$@" ; do
    echo "Installing '$package'..."
    if ! sudo $INSTPROG install -y "$package" >/tmp/pkg-install-${package}.log 2>&1 ; then
      echo "${PROGNAME:+$PROGNAME: }WARN: There was an error installing package '$package' - see '/tmp/pkg-install-${package}.log'." 1>&2
    fi
  done
}

_print_header () {
  echo "################################################################################"
  echo "$@"
}

# #############################################################################
_print_header "Debian desktop package selects"

echo "Debian APT index update..."
if ! sudo $APTPROG update >/dev/null 2>/tmp/apt-update-err.log ; then
  echo "WARN: There was some failure during APT index update - see '/tmp/apt-update-err.log'." 1>&2
fi

echo ${BASH_VERSION:+-e} "Debian desktop - educational packages..."
_install_packages gperiodic

echo ${BASH_VERSION:+-e} "Debian desktop - multimedia packages..."
_install_packages mp3splt parole ristretto

echo ${BASH_VERSION:+-e} "Debian desktop - networking packages..."
_install_packages gigolo # remote filesystem management

echo ${BASH_VERSION:+-e} "Debian desktop - productivity packages..."
_install_packages atril galculator guake meld
_install_packages gnome-shell-pomodoro

echo ${BASH_VERSION:+-e} "Debian desktop - miscellaneous packages..."
_install_packages autorenamer
_install_packages slop # GUI region selection, used by other apps such as screenkey

# #############################################################################
_print_header "Debian APT repository clean up..."

sudo $APTPROG autoremove -y
sudo $APTPROG clean -y

# #############################################################################
_print_header "Debian GUI app recommendations > ~/README-debian-gui-apps.lst"

cat <<EOF | tee ~/README-debian-gui-apps.lst
# Favorites
{
sudo $INSTPROG update

# Apps
sudo $INSTPROG install -y gnucash
sudo $INSTPROG install -y gtypist tuxtype
sudo $INSTPROG install -y libreoffice-calc

# Games
sudo $INSTPROG install -y chocolate-doom
sudo $INSTPROG install -y dosbox stella zsnes
sudo $INSTPROG install -y gnome-games gnome-sudoku gnuchess
sudo $INSTPROG install -y openttd openttd-opengfx openttd-openmsx openttd-opensfx timidity
}

# Etc - Desktop
sudo $INSTPROG install -y bum
sudo $INSTPROG install -y ssh-askpass
sudo $INSTPROG install -y xbacklight xclip xscreensaver

# Etc - Drivers - Have linux-headers-... installed.
sudo $INSTPROG install -y "nvidia-kernel-$(uname -r)" nvidia-{settings,xconfig}

# Etc - Games
sudo $INSTPROG install -y joy2key joystick inputattach
sudo $INSTPROG install -y visualboyadvance-gtk

# Etc - Multimedia
sudo $INSTPROG install -y asunder # CD ripper
sudo $INSTPROG install -y gnome-alsamixer pulseaudio-equalizer pavucontrol volumeicon-alsa
sudo $INSTPROG install -y audacious audacious-plugins
sudo $INSTPROG install -y mpv

# Etc - Networking
sudo $INSTPROG install -y mobile-broadband-provider-info modemmanager usb-modeswitch # mobile modem

# Etc - Productivity
sudo $INSTPROG install -y shutter # screenshots

# Etc - System
sudo $INSTPROG install -y ntfs-3g
EOF

# #############################################################################
# Finish

echo "FINISHED Debian desktop package installations"
echo
