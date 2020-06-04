#!/usr/bin/env bash

PROGNAME="apps-debian-desktop.sh"
export APTPROG=apt-get
export INSTPROG=apt-get

if ! egrep -i -q -r 'debi|ubun' /etc/*release ; then echo "$PROGNAME: SKIP: De/b/untu-like supported only" ; exit ; fi

echo "$PROGNAME: INFO: Debian desktop package selections"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"


_install_packages () {
  for package in "$@" ; do
    if dpkg -s "${package}" >/dev/null 2>&1 ; then
      echo "$PROGNAME: SKIP: Package '${package}' already installed..."
    else
      echo "$PROGNAME: INFO: Installing '${package}'..."
      if ! sudo $INSTPROG install -y "${package}" >/tmp/pkg-install-${package}.log 2>&1 ; then
        echo "$PROGNAME: WARN: There was an error installing package '${package}' - see '/tmp/pkg-install-${package}.log'." 1>&2
      fi
    fi
  done
}


# #############################################################################
echo "$PROGNAME: INFO: Debian APT index update..."

if ! sudo $APTPROG update >/dev/null 2>/tmp/apt-update-err.log ; then
  echo "$PROGNAME: WARN: There was some failure during APT index update - see '/tmp/apt-update-err.log'." 1>&2
fi

# #############################################################################
# Installations

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
sudo apt-get update

# Apps
sudo apt-get install -y gnucash
sudo apt-get install -y gtypist tuxtype
sudo apt-get install -y libreoffice-calc

# Games
sudo apt-get install -y chocolate-doom
sudo apt-get install -y dosbox stella zsnes
sudo apt-get install -y gnome-games gnome-sudoku gnuchess
sudo apt-get install -y openttd openttd-opengfx openttd-openmsx openttd-opensfx timidity
}

# Etc - Desktop
sudo apt-get install -y bum
sudo apt-get install -y ssh-askpass
sudo apt-get install -y xbacklight xclip xscreensaver

# Etc - Drivers - Have linux-headers-... installed.
sudo apt-get install -y "nvidia-kernel-$(uname -r)" nvidia-{settings,xconfig}

# Etc - Games
sudo apt-get install -y joy2key joystick inputattach
sudo apt-get install -y visualboyadvance \
  || sudo apt-get install -y visualboyadvance-gtk

# Etc - Multimedia
sudo apt-get install -y asunder # CD ripper
sudo apt-get install -y gnome-alsamixer pulseaudio-equalizer pavucontrol volumeicon-alsa
sudo apt-get install -y audacious audacious-plugins
sudo apt-get install -y mpv

# Etc - Networking
sudo apt-get install -y mobile-broadband-provider-info modemmanager usb-modeswitch # mobile modem

# Etc - Productivity
sudo apt-get install -y shutter # screenshots

# Etc - System
sudo apt-get install -y ntfs-3g
EOF

echo "$PROGNAME: COMPLETE: Debian desktop package selections"
exit
