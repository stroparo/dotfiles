#!/usr/bin/env bash

# #############################################################################
# Globals

export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf

URL_FLASH='http://linuxdownload.adobe.com/adobe-release/adobe-release-x86_64-1.0-1.noarch.rpm'
URL_STACER='https://github.com/oguzhaninan/Stacer/releases/download/v1.0.8/stacer-1.0.8_x64.rpm'

# #############################################################################
# Check OS

if ! egrep -i -q 'cent ?os|fedora|oracle|red ?hat' /etc/*release* 2>/dev/null
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
$RPMPROG install sudo
visudo
EOF
  exit 1
fi

# #############################################################################
# Hostname

echo ${BASH_VERSION:+-e} "\n==> Skip hostname setup? [Y/n]\c" ; read answer
if [[ $answer = n ]] ; then
  echo ${BASH_VERSION:+-e} "Hostname: \c" ; read newhostname
  sudo hostnamectl set-hostname "${newhostname:-andromeda}"
fi

# #############################################################################
# Upgrade

echo ${BASH_VERSION:+-e} "\n==> Upgrade all packages? [y/N]\c" ; read answer
[[ $answer = y ]] && sudo $RPMPROG update

# #############################################################################
# Install

sudo $RPMPROG install gigolo guake meld

# Multimedia
sudo $RPMPROG install audacious audacious-plugins-freeworld
sudo $RPMPROG install mplayer parole

# Networking
sudo $RPMPROG install qbittorrent transmission

# Productivity
sudo $RPMPROG install libreoffice-calc

# #############################################################################
# Fedora

if egrep -i -q 'fedora' /etc/*release* 2>/dev/null ; then

  if which dnf >/dev/null 2>&1 ; then

    echo
    echo '==> DNF Delta RPM compression...'

    sudo dnf install deltarpm \
      && (echo "deltarpm=1" | sudo tee -a /etc/dnf/dnf.conf)
  fi

  echo
  echo '==> Google Chrome...'

  sudo rpm --import https://dl.google.com/linux/linux_signing_key.pub
  sudo tee /etc/yum.repos.d/google-chrome.repo <<RPMREPO
[google-chrome]
name=google-chrome
baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl.google.com/linux/linux_signing_key.pub
RPMREPO
  sudo $RPMPROG install google-chrome-stable

  echo
  echo '==> Flash Player...'

  sudo $RPMPROG install "$URL_FLASH"
  sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux
  sudo $RPMPROG install flash-plugin

  echo
  echo "==> Stacer monitor dashboard..."

  curl -kLSf -o ~/stacer.rpm "$URL_STACER" \
    && $RPMPROG install ~/stacer.rpm

  if which dnf >/dev/null 2>&1 ; then

    echo
    echo '==> skypeforlinux installation prep...'

    sudo dnf config-manager --add-repo 'https://repo.skype.com/data/skype-stable.repo'
    sudo rpm --import 'https://repo.skype.com/data/SKYPE-GPG-KEY'
    sudo dnf update
    echo
    echo '==> skypeforlinux installation...'
    sudo dnf install skypeforlinux
  fi
fi

# #############################################################################
# Fedora 27

if egrep -i -q 'fedora 27' /etc/*release* 2>/dev/null ; then

  echo
  echo '==> Fedora 27...'

  echo
  echo '==> RPMFusion repo...'
  {
    sudo $RPMPROG install http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-27.noarch.rpm
    sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-free-fedora-27
    sudo $RPMPROG install http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-27.noarch.rpm
    sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-nonfree-fedora-27
    sudo $RPMPROG update

    echo
    echo '==> RPMFusion - codecs...'
    sudo $RPMPROG install amrnb amrwb faad2 flac ffmpeg gpac-libs lame libfc14audiodecoder mencoder mplayer x264 x265 gstreamer-plugins-espeak gstreamer-plugins-fc gstreamer-rtsp gstreamer-plugins-good gstreamer-plugins-bad gstreamer-plugins-bad-free-extras gstreamer-plugins-bad-nonfree gstreamer-plugins-ugly gstreamer-ffmpeg gstreamer1-plugins-base gstreamer1-libav gstreamer1-plugins-bad-free-extras gstreamer1-plugins-bad-freeworld gstreamer1-plugins-base-tools gstreamer1-plugins-good-extras gstreamer1-plugins-ugly gstreamer1-plugins-bad-free gstreamer1-plugins-good

    echo
    echo '==> RPMFusion - virtualbox...'
    sudo $RPMPROG install VirtualBox
  }

  echo
  # echo '==> Graphics drivers...'

  # VGA AMD closed
  # sudo $RPMPROG install mesa-dri-drivers.i686 mesa-libGL.i686 xorg-x11-drv-amdgpu
  # VGA Intel
  # sudo $RPMPROG install mesa-dri-drivers.i686 mesa-libGL.i686 xorg-x11-drv-intel
  # VGA Nvidia closed
  # sudo $RPMPROG install xorg-x11-drv-nvidia-libs.i686
  # VGA Nvidia open
  # sudo $RPMPROG install mesa-dri-drivers.i686 mesa-libGL.i686 xorg-x11-drv-nouveau

  if which dnf >/dev/null 2>&1 ; then

    echo
    echo '==> Steam...'

    sudo dnf config-manager --add-repo=http://negativo17.org/repos/fedora-steam.repo
    sudo dnf install steam
  fi
fi

# #############################################################################
# Fedora 26 & 27

if egrep -i -q 'fedora 2[67]' /etc/*release* 2>/dev/null ; then

  echo
  echo '==> Fedora 26 & 27...'

  fedora_version=$(egrep -i -o 'fedora 2[67]' /etc/*release* 2>/dev/null \
    | head -1 \
    | awk '{ print $2; }')

  echo
  echo '==> XFCE Whisker Menu'

  sudo $RPMPROG remove xfce4-whiskermenu-plugin
  sudo curl -kLSf -o /etc/yum.repos.d/home:gottcode.repo \
    "http://download.opensuse.org/repositories/home:\
/gottcode/Fedora_${fedora_version}/home:\
gottcode.repo"
  sudo $RPMPROG install xfce4-whiskermenu-plugin
fi

# #############################################################################

