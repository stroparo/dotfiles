#!/usr/bin/env bash

# Cristian Stroparo's dotfiles

# #############################################################################
# Globals

if [ -z "$INSTPROG" ] ; then
  export INSTPROG=yum
  which dnf >/dev/null 2>&1 && export INSTPROG=dnf
fi

URL_FLASH='http://linuxdownload.adobe.com/adobe-release/adobe-release-x86_64-1.0-1.noarch.rpm'
URL_STACER='https://github.com/oguzhaninan/Stacer/releases/download/v1.0.8/stacer-1.0.8_x64.rpm'

# #############################################################################
# Check OS

if ! egrep -i -q 'cent ?os|fedora|oracle|red ?hat' /etc/*release 2>/dev/null
then
  echo "FATAL: Only Red Hat based distros are supported" 1>&2
  exit 1
fi

# #############################################################################
# Sudo check

if ! which sudo ; then
  echo "FATAL: Please setup sudo for your user first.." 1>&2
  cat "Suggested commands:" <<EOF
su -
$INSTPROG install sudo
visudo
EOF
  exit 1
fi

# #############################################################################
# Upgrade

echo ${BASH_VERSION:+-e} "\n==> Upgrade all packages? [y/N]\c" ; read answer
[[ $answer = y ]] && sudo $INSTPROG update -y

# #############################################################################
# Install

echo ${BASH_VERSION:+-e} "\n==> Base desktop packages..."
sudo $INSTPROG install -q -y x11-ssh-askpass xbacklight xclip
sudo $INSTPROG install -q -y gnome-themes-standard

echo ${BASH_VERSION:+-e} "\n==> Productivity..."
sudo $INSTPROG install -q -y atril galculator guake meld
sudo $INSTPROG install -q -y gnome-shell-extension-pomodoro
sudo $INSTPROG install -q -y shutter # screenshots

# #############################################################################
# Fedora

if egrep -i -q 'fedora' /etc/*release 2>/dev/null ; then

  if which dnf >/dev/null 2>&1 ; then
    echo
    echo '==> DNF Delta RPM compression...'
    sudo dnf install -q -y deltarpm \
      && (echo "deltarpm=1" | sudo tee -a /etc/dnf/dnf.conf)
  fi

  echo
  echo '==> Flash Player...'

  sudo $INSTPROG install -q -y "$URL_FLASH"
  sudo rpm --import --quiet /etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux
  sudo $INSTPROG install -q -y flash-plugin

  echo
  echo "==> Stacer monitor dashboard..."

  curl -kLSf -o ~/stacer.rpm "$URL_STACER" \
    && $INSTPROG install -q -y ~/stacer.rpm \
    && rm ~/stacer.rpm

  if which dnf >/dev/null 2>&1 ; then

    echo
    echo '==> skypeforlinux installation prep...'

    sudo dnf config-manager --add-repo 'https://repo.skype.com/data/skype-stable.repo'
    sudo rpm --import --quiet 'https://repo.skype.com/data/SKYPE-GPG-KEY'
    sudo dnf update
    echo
    echo '==> skypeforlinux installation...'
    sudo dnf install -q -y skypeforlinux
  fi
fi

# #############################################################################
# Fedora 27

if egrep -i -q 'fedora 27' /etc/*release 2>/dev/null ; then

  echo
  echo '==> Fedora 27...'

  echo
  echo '==> RPMFusion repo...'
  {
    sudo $INSTPROG install -q -y http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-27.noarch.rpm
    sudo rpm --import --quiet /etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-free-fedora-27
    sudo $INSTPROG install -q -y http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-27.noarch.rpm
    sudo rpm --import --quiet /etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-nonfree-fedora-27
    sudo $INSTPROG update -y

    echo
    echo '==> RPMFusion - codecs...'
    sudo $INSTPROG install -q -y amrnb amrwb faad2 flac ffmpeg gpac-libs lame libfc14audiodecoder mencoder mplayer x264 x265 gstreamer-plugins-espeak gstreamer-plugins-fc gstreamer-rtsp gstreamer-plugins-good gstreamer-plugins-bad gstreamer-plugins-bad-free-extras gstreamer-plugins-bad-nonfree gstreamer-plugins-ugly gstreamer-ffmpeg gstreamer1-plugins-base gstreamer1-libav gstreamer1-plugins-bad-free-extras gstreamer1-plugins-bad-freeworld gstreamer1-plugins-base-tools gstreamer1-plugins-good-extras gstreamer1-plugins-ugly gstreamer1-plugins-bad-free gstreamer1-plugins-good

    echo
    echo '==> RPMFusion - virtualbox...'
    sudo $INSTPROG install -q -y virtualbox
  }

  echo
  # echo '==> Graphics drivers...'

  # VGA AMD closed
  # sudo $INSTPROG install -q -y mesa-dri-drivers.i686 mesa-libGL.i686 xorg-x11-drv-amdgpu
  # VGA Intel
  # sudo $INSTPROG install -q -y mesa-dri-drivers.i686 mesa-libGL.i686 xorg-x11-drv-intel
  # VGA Nvidia closed
  # sudo $INSTPROG install -q -y xorg-x11-drv-nvidia-libs.i686
  # VGA Nvidia open
  # sudo $INSTPROG install -q -y mesa-dri-drivers.i686 mesa-libGL.i686 xorg-x11-drv-nouveau

  if which dnf >/dev/null 2>&1 ; then

    echo
    echo '==> Steam...'

    sudo dnf config-manager --add-repo=http://negativo17.org/repos/fedora-steam.repo
    sudo dnf install -q -y steam
  fi
fi

# #############################################################################
echo
echo "==> Suggestions"

cat <<EOF

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

