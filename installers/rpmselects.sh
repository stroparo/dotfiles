#!/usr/bin/env bash

# Cristian Stroparo's dotfiles - https://github.com/stroparo/dotfiles

# Custom RPM package selection

# #############################################################################
# Globals

PROGNAME=rpmselects.sh

if [ -z "$RPMPROG" ] ; then
  export RPMPROG=yum
  which dnf >/dev/null 2>&1 && export RPMPROG=dnf
fi

if [ -z "$RPMGROUP" ] ; then
  export RPMGROUP="yum groupinstall"
  which dnf >/dev/null 2>&1 && export RPMGROUP="dnf group install"
fi

# #############################################################################
# Check OS

if ! egrep -i -q 'cent ?os|fedora|oracle|red ?hat' /etc/*release ; then
  echo "FATAL: Only Red Hat based distros are allowed to call this script ($0)" 1>&2
  exit 1
fi

# #############################################################################
# Sudo check

if ! which sudo ; then
  echo "FATAL: Please log in as root, install and then configure sudo for your user first.." 1>&2
  cat "Suggested commands:" <<EOF
su -
$RPMPROG install sudo
visudo
EOF
  exit 1
fi

# #############################################################################
# EPEL (Extra Packages for Enterprise Linux)
# https://fedoraproject.org/wiki/EPEL

echo ${BASH_VERSION:+-e} \
  "\n\n==> EPEL (Extra Packages for Enterprise Linux)..."

if ! grep -i -q 'fedora' /etc/*release ; then
  if egrep -i -q '(centos|oracle|red *hat).* 7' /etc/*release ; then
    sudo $RPMPROG -y install \
      https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  else
    sudo $RPMPROG install -q -y epel-release.noarch
  fi
fi

# #############################################################################
# Main

if [ -n "$NEWHOSTNAME" ] ; then
  echo "==> Setting up hostname to '${NEWHOSTNAME}'..." 1>&2
  sudo hostnamectl set-hostname "${NEWHOSTNAME:-andromeda}"
fi

sudo yum makecache fast
# sudo $RPMPROG update -y

echo ${BASH_VERSION:+-e} "\n\n==> Base packages..."
sudo $RPMPROG install -q -y curl lftp rsync wget
sudo $RPMPROG install -q -y --enablerepo=epel mosh
sudo $RPMPROG install -q -y less
sudo $RPMPROG install -q -y --enablerepo=epel p7zip p7zip-plugins lzip cabextract unrar
which tmux >/dev/null 2>&1 || sudo $RPMPROG install -q -y tmux
sudo $RPMPROG install -q -y sqlite libdbi-dbd-sqlite
sudo $RPMPROG install -q -y --enablerepo=epel the_silver_searcher # ag
sudo $RPMPROG install -q -y unzip zip
sudo $RPMPROG install -q -y zsh

echo ${BASH_VERSION:+-e} "\n\n==> Devel packages..."

sudo $RPMGROUP -q -y --enablerepo=epel 'Development Tools'
sudo $RPMPROG install -q -y ctags
# sudo $RPMPROG install -q -y golang
sudo $RPMPROG install -q -y --enablerepo=epel jq
sudo $RPMPROG install -q -y make
sudo $RPMPROG install -q -y perl perl-devel perl-ExtUtils-Embed
# sudo $RPMPROG install -q -y ruby ruby-devel
sudo $RPMPROG install -q -y --enablerepo=epel tig # git

echo ${BASH_VERSION:+-e} "\n==> Security..."
sudo $INSTPROG install -q -y gnupg pwgen
sudo $INSTPROG install -q -y oathtool oath-toolkit

# #############################################################################
# SELinux

echo ${BASH_VERSION:+-e} "\n\n==> SELinux..."
sudo $RPMPROG install -q -y setroubleshoot-server selinux-policy-devel

# #############################################################################
# Specific to the distribution

sudo $RPMPROG install -q -y yum-utils

