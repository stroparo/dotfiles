#!/usr/bin/env bash

# Cristian Stroparo's dotfiles
# Custom RPM package selection for desktop environments

PROGNAME=rpmselects-desktop.sh

# #############################################################################
# Check OS

if ! egrep -i -q 'cent ?os|fedora|oracle|red ?hat' /etc/*release 2>/dev/null ; then
  echo "${PROGNAME:+$PROGNAME: }SKIP: Only Red Hat based distros are supported" 1>&2
  exit
fi

# #############################################################################
# Globals

# System installers
export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf
export RPMGROUP="yum groupinstall"; which dnf >/dev/null 2>&1 && export RPMGROUP="dnf group install"
export INSTPROG="$RPMPROG"

# URLs
URL_FLASH='http://linuxdownload.adobe.com/adobe-release/adobe-release-x86_64-1.0-1.noarch.rpm'
URL_STACER='https://github.com/oguzhaninan/Stacer/releases/download/v1.0.8/stacer-1.0.8_x64.rpm'

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

_print_bar () {
  echo "################################################################################"
}

_print_header () {
  _print_bar
  echo "$@"
  _print_bar
}

# #############################################################################
# Main

_print_header "EL Enterprise Linux desktop package selects"

echo ${BASH_VERSION:+-e} "\n==> Base desktop packages..."
_install_packages x11-ssh-askpass xbacklight xclip
_install_packages gnome-themes-standard

echo ${BASH_VERSION:+-e} "\n==> Productivity..."
_install_packages atril galculator guake meld
_install_packages gnome-shell-extension-pomodoro
_install_packages shutter # screenshots

# #############################################################################
# Fedora

if egrep -i -q 'fedora' /etc/*release 2>/dev/null ; then

  if which dnf >/dev/null 2>&1 ; then
    echo
    echo 'Fedora - DNF Delta RPM compression...'
    sudo dnf install -q -y deltarpm \
      && (echo "deltarpm=1" | sudo tee -a /etc/dnf/dnf.conf)
  fi

  echo
  echo 'Fedora - Flash Player...'

  _install_packages "$URL_FLASH"
  sudo rpm --import --quiet /etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux
  _install_packages flash-plugin

  echo
  echo "Fedora - Stacer monitor dashboard..."

  curl -kLSf -o ~/stacer.rpm "$URL_STACER" \
    && $INSTPROG install -q -y ~/stacer.rpm \
    && rm ~/stacer.rpm

  if which dnf >/dev/null 2>&1 ; then

    echo
    echo 'Fedora - skypeforlinux installation prep...'

    sudo dnf config-manager --add-repo 'https://repo.skype.com/data/skype-stable.repo'
    sudo rpm --import --quiet 'https://repo.skype.com/data/SKYPE-GPG-KEY'
    sudo dnf update
    echo
    echo 'Fedora - skypeforlinux installation...'
    sudo dnf install -q -y skypeforlinux
  fi
fi

# #############################################################################
# Fedora 27

if egrep -i -q 'fedora 27' /etc/*release 2>/dev/null ; then

  _print_header "Fedora 27"

  echo 'Fedora 27 - RPMFusion repo...'
  {
    _install_packages http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-27.noarch.rpm
    sudo rpm --import --quiet /etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-free-fedora-27
    _install_packages http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-27.noarch.rpm
    sudo rpm --import --quiet /etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-nonfree-fedora-27
    sudo $INSTPROG update -y

    echo 'Fedora 27 - RPMFusion - codecs...'
    _install_packages amrnb amrwb faad2 flac ffmpeg gpac-libs lame libfc14audiodecoder mencoder mplayer x264 x265 gstreamer-plugins-espeak gstreamer-plugins-fc gstreamer-rtsp gstreamer-plugins-good gstreamer-plugins-bad gstreamer-plugins-bad-free-extras gstreamer-plugins-bad-nonfree gstreamer-plugins-ugly gstreamer-ffmpeg gstreamer1-plugins-base gstreamer1-libav gstreamer1-plugins-bad-free-extras gstreamer1-plugins-bad-freeworld gstreamer1-plugins-base-tools gstreamer1-plugins-good-extras gstreamer1-plugins-ugly gstreamer1-plugins-bad-free gstreamer1-plugins-good

    echo 'Fedora 27 - RPMFusion - virtualbox...'
    _install_packages virtualbox
  }

  # echo 'Fedora 27 - Graphics drivers...'

  # VGA AMD closed
  # sudo $INSTPROG install -q -y mesa-dri-drivers.i686 mesa-libGL.i686 xorg-x11-drv-amdgpu
  # VGA Intel
  # sudo $INSTPROG install -q -y mesa-dri-drivers.i686 mesa-libGL.i686 xorg-x11-drv-intel
  # VGA Nvidia closed
  # sudo $INSTPROG install -q -y xorg-x11-drv-nvidia-libs.i686
  # VGA Nvidia open
  # sudo $INSTPROG install -q -y mesa-dri-drivers.i686 mesa-libGL.i686 xorg-x11-drv-nouveau

  if which dnf >/dev/null 2>&1 ; then
    echo 'Fedora 27 - Steam...'
    sudo dnf config-manager --add-repo=http://negativo17.org/repos/fedora-steam.repo
    sudo dnf install -q -y steam
  fi
fi

# #############################################################################
echo
echo "==> Suggestions"

cat <<EOF | tee ~/README-el-gui-apps.lst

# Antivirus command freshclam...
sudo $INSTPROG install -q -y clamtk clamav clamav-update

# Educational...
sudo $INSTPROG install -q -y gnome-chemistry-utils

# Games...
sudo $INSTPROG install -q -y dosbox
sudo $INSTPROG install -q -y openttd openttd-opengfx timidity++

# Multimedia...
sudo $INSTPROG install -q -y audacious audacious-plugins-freeworld
sudo $INSTPROG install -q -y parole
sudo $INSTPROG install -q -y ristretto

# Networking...
sudo $INSTPROG install -q -y gigolo # remote filesystem management

# Productivity...
sudo $INSTPROG install -q -y gnucash
sudo $INSTPROG install -q -y libreoffice-calc

EOF

# #############################################################################

