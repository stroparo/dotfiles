#!/usr/bin/env bash

PROGNAME="apps-debian-desktop.sh"
export APTPROG=apt-get
export INSTPROG=apt-get
export INSTCKPROG="dpkg -s"

if ! egrep -i -q -r 'debi|ubun' /etc/*release ; then echo "$PROGNAME: SKIP: De/b/untu-like supported only" ; exit ; fi

echo "$PROGNAME: INFO: Debian desktop package selections"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"


_install_packages () {
  typeset filestamp="$(date '+%Y%m%d-%OH%OM%OS')"

  for package in "$@" ; do
    if eval ${INSTCKPROG} "${package}" >/dev/null 2>&1 ; then
      echo "$PROGNAME: SKIP: Package '${package}' already installed..."
    else
      echo "$PROGNAME: INFO: Installing '${package}'..."
      if ! sudo $INSTPROG install -y "${package}" >/tmp/pkg-install-${filestamp}-${package}.log 2>&1 ; then
        echo "${PROGNAME}: WARN: There was an error installing packages - see '/tmp/pkg-install-${filestamp}-${package}.log'." 1>&2
      fi
    fi
  done
}


# #############################################################################
echo "$PROGNAME: INFO: APT index update..."

if ! sudo $APTPROG update >/dev/null 2>/tmp/apt-update-err.log ; then
  echo "$PROGNAME: WARN: There was some failure during APT index update - see '/tmp/apt-update-err.log'." 1>&2
fi

# #############################################################################
# Installations

echo "$PROGNAME: INFO: Educational packages..."
_install_packages gperiodic gtypist tuxtype

echo "$PROGNAME: INFO: Entertainment packages..."
_install_packages chocolate-doom
_install_packages dosbox stella zsnes
_install_packages gnome-games gnome-sudoku gnuchess
_install_packages openttd openttd-opengfx openttd-openmsx openttd-opensfx timidity
_install_packages visualboyadvance \
  || _install_packages visualboyadvance-gtk

echo "$PROGNAME: INFO: Multimedia packages..."
_install_packages geeqie exiftool ristretto  # exiftool for cropping images from within geeqie
_install_packages mp3splt
_install_packages mpv parole smplayer

echo "$PROGNAME: INFO: Networking packages..."
_install_packages gigolo  # remote filesystem management

echo "$PROGNAME: INFO: Ops packages..."
_install_packages stacer  # system monitoring; Ubuntu 20.04+, before it was under the 'oguzhaninan/stacer' PPA

echo "$PROGNAME: INFO: Productivity packages..."
_install_packages atril galculator guake meld
_install_packages flameshot  # take screenshots, annotate etc.
_install_packages gnome-shell-pomodoro

echo "$PROGNAME: INFO: Networking packages..."
_install_packages blueman bluez

echo "$PROGNAME: INFO: Security packages..."
_install_packages clamav libclamunrar6

echo "$PROGNAME: INFO: Miscellaneous packages..."
_install_packages autorenamer
_install_packages dconf-editor
_install_packages qdirstat  # Ubuntu 20.04+, before it was under the 'nathan-renniewaldock/qdirstat' PPA
_install_packages slop  # GUI region selection, used by other apps such as screenkey
_install_packages xdotool wmctrl  # deps for jc00ke/move-to-next-monitor

echo "$PROGNAME: INFO: APT repository clean up..."
sudo $APTPROG autoremove -y
sudo $APTPROG clean -y

echo "$PROGNAME: INFO: APT package for flatpak..."
if ! type flatpak >/dev/null 2>&1 ; then
  sudo apt install flatpak
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

echo "$PROGNAME: INFO: GUI app recommendations > ~/README-debian-gui-apps.lst"
cat <<EOF | tee "${HOME}/README-debian-gui-apps.lst"
sudo apt-get update

# Apps - Desktop
sudo apt-get install -y bum
sudo apt-get install -y ssh-askpass
sudo apt-get install -y xbacklight xclip xscreensaver

# Apps - Drivers - Have linux-headers-... installed.
sudo apt-get install -y "nvidia-kernel-$(uname -r)" nvidia-{settings,xconfig}

# Apps - Games
sudo apt-get install -y joy2key joystick inputattach

# Apps - Multimedia
sudo apt-get install -y asunder # CD ripper
sudo apt-get install -y gnome-alsamixer pulseaudio-equalizer pavucontrol volumeicon-alsa
sudo apt-get install -y audacious audacious-plugins

# Apps - Networking
sudo apt-get install -y mobile-broadband-provider-info modemmanager usb-modeswitch # mobile modem

# Apps - Productivity
sudo apt-get install -y libreoffice-calc

# Apps - Security
sudo apt-get install -y clamav-daemon

# Apps - System
sudo apt-get install -y ntfs-3g
EOF

echo "$PROGNAME: COMPLETE: Debian desktop package selections"
exit
