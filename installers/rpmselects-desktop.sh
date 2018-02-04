#!/usr/bin/env bash

# #############################################################################
# Globals

export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf

# #############################################################################
# Check OS

if ! egrep -i -q 'cent ?os|fedora|oracle|red ?hat' /etc/*release* ; then
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
# Upgrade

echo ${BASH_VERSION:+-e} "\n==> Upgrade all packages? [y/N]\c" ; read answer
[[ $answer = y ]] && sudo $RPMPROG update

# #############################################################################
# Install

sudo $RPMPROG install gigolo guake meld
sudo $RPMPROG install libreoffice-calc
sudo $RPMPROG install mplayer parole

# #############################################################################
# Fedora 27

if egrep -i -q 'fedora 27' /etc/*release* ; then
  echo "==> Fedora 27 codecs..."
  sudo $RPMPROG install http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-27.noarch.rpm
  sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-free-fedora-27
  sudo $RPMPROG install http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-27.noarch.rpm
  sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-nonfree-fedora-27
  sudo $RPMPROG install amrnb amrwb faad2 flac ffmpeg gpac-libs lame libfc14audiodecoder mencoder mplayer x264 x265 gstreamer-plugins-espeak gstreamer-plugins-fc gstreamer-rtsp gstreamer-plugins-good gstreamer-plugins-bad gstreamer-plugins-bad-free-extras gstreamer-plugins-bad-nonfree gstreamer-plugins-ugly gstreamer-ffmpeg gstreamer1-plugins-base gstreamer1-libav gstreamer1-plugins-bad-free-extras gstreamer1-plugins-bad-freeworld gstreamer1-plugins-base-tools gstreamer1-plugins-good-extras gstreamer1-plugins-ugly gstreamer1-plugins-bad-free gstreamer1-plugins-good
fi

# #############################################################################
# Fedora 26 & 27

if egrep -i -q 'fedora 2[67]' /etc/*release* ; then

  echo
  echo "==> Fedora 26 & 27..."

  fedora_version=$(egrep -i -o 'fedora 2[67]' /etc/*release* \
    | head -1 \
	| awk '{ print $2; }')

  echo
  echo "==> XFCE Whisker Menu"
  sudo $RPMPROG remove xfce4-whiskermenu-plugin
  sudo curl -kLSf -o /etc/yum.repos.d/home:gottcode.repo \
    "http://download.opensuse.org/repositories/home:\
/gottcode/Fedora_${fedora_version}/home:\
gottcode.repo"
  sudo $RPMPROG install xfce4-whiskermenu-plugin
fi

# #############################################################################

