#!/usr/bin/env bash

PROGNAME="apps-debian-desktop.sh"

if ! egrep -i -q -r 'debi|ubun' /etc/*release ; then echo "PROGNAME: SKIP: De/b/untu-like supported only" ; exit ; fi

echo "$PROGNAME: INFO: Debian desktop package selections"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Globals

# System installers
export APTPROG=apt-get; which apt >/dev/null 2>&1 && export APTPROG=apt
export INSTPROG="$APTPROG"

# #############################################################################
# Helpers


_install_packages () {
  for package in "$@" ; do
    echo "$PROGNAME: INFO: Installing '$package'..."
    if ! sudo $INSTPROG install -y "$package" >/tmp/pkg-install-${package}.log 2>&1 ; then
      echo "$PROGNAME: WARN: There was an error installing package '$package' - see '/tmp/pkg-install-${package}.log'." 1>&2
    fi
  done
}


# #############################################################################

echo "$PROGNAME: INFO: Debian APT index update..."
if ! sudo $APTPROG update >/dev/null 2>/tmp/apt-update-err.log ; then
  echo "$PROGNAME: WARN: There was some failure during APT index update - see '/tmp/apt-update-err.log'." 1>&2
fi

echo "$PROGNAME: INFO: Debian desktop - educational packages..."
_install_packages gperiodic

echo "$PROGNAME: INFO: Debian desktop - multimedia packages..."
_install_packages mp3splt parole ristretto

echo "$PROGNAME: INFO: Debian desktop - networking packages..."
_install_packages gigolo # remote filesystem management

echo "$PROGNAME: INFO: Debian desktop - productivity packages..."
_install_packages atril galculator guake meld
_install_packages gnome-shell-pomodoro

echo "$PROGNAME: INFO: Debian desktop - miscellaneous packages..."
_install_packages autorenamer
_install_packages slop # GUI region selection, used by other apps such as screenkey

echo "$PROGNAME: INFO: Debian APT repository clean up..."
sudo $APTPROG autoremove -y
sudo $APTPROG clean -y

echo "$PROGNAME: INFO: Debian APT package for flatpak..."
if ! type flatpak >/dev/null 2>&1 ; then
  sudo apt install flatpak
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

echo "$PROGNAME: INFO: Debian GUI app recommendations > ~/README-debian-gui-apps.lst"
cat <<EOF | tee "${HOME}/README-debian-gui-apps.lst"
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

echo "$PROGNAME: COMPLETE: Debian desktop package selections"
exit
