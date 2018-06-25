#!/usr/bin/env bash

# Cristian Stroparo's dotfiles
# Custom Debian package selection for desktop environments

PROGNAME=apps-debian-desktop.sh

# #############################################################################
# Checks

if ! egrep -i -q 'debian|ubuntu' /etc/*release ; then
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
  echo "################################################################################"
}

# #############################################################################
_print_header "Debian desktop package selects"

echo "Debian APT index update..."
if ! sudo $APTPROG update >/dev/null 2>/tmp/apt-update-err.log ; then
  echo "WARN: There was some failure during APT index update - see '/tmp/apt-update-err.log'." 1>&2
fi

echo ${BASH_VERSION:+-e} "Debian desktop - base packages..."
_install_packages bum ssh-askpass xbacklight xclip xscreensaver
_install_packages ntfs-3g

echo ${BASH_VERSION:+-e} "Debian desktop - educational packages..."
_install_packages gperiodic

echo ${BASH_VERSION:+-e} "Debian desktop - productivity packages..."
_install_packages atril galculator guake meld
_install_packages gnome-shell-pomodoro

echo ${BASH_VERSION:+-e} "Debian desktop - miscellaneous packages..."
_install_packages autorenamer

# #############################################################################
_print_header "Debian APT repository clean up..."

sudo $APTPROG autoremove -y
sudo $APTPROG clean -y

# #############################################################################
_print_header "Debian GUI app recommendations"

cat <<EOF | tee ~/README-debian-gui-apps.lst

# Drivers - Have linux-headers-... installed.
sudo aptitude install -y "nvidia-kernel-$(uname -r)" nvidia-{settings,xconfig}

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
sudo $INSTPROG install -y gnome-alsamixer pulseaudio-equalizer pavucontrol volumeicon-alsa
sudo $INSTPROG install -y audacious audacious-plugins
sudo $INSTPROG install -y mp3splt
sudo $INSTPROG install -y mpv
sudo $INSTPROG install -y parole
sudo $INSTPROG install -y ristretto

# Networking
sudo $INSTPROG install -y gigolo # remote filesystem management
sudo $INSTPROG install -y mobile-broadband-provider-info modemmanager usb-modeswitch # mobile modem

# Productivity
sudo $INSTPROG install -y gnucash
sudo $INSTPROG install -y libreoffice-calc
sudo $INSTPROG install -y shutter # screenshots

EOF

# #############################################################################

