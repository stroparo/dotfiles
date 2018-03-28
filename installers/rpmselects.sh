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
      echo "${PROGNAME:+$PROGNAME: }INFO: Disabled epel (use --enablerepo=epel) from now on..." 1>&2
    sudo sed -i -e "s/^enabled=1/enabled=0/" /etc/yum.repos.d/epel.repo
  else
    sudo $RPMPROG install -y epel-release.noarch
  fi
fi

# #############################################################################
# Main

if [ -n "$NEWHOSTNAME" ] ; then
  echo "==> Setting up hostname to '${NEWHOSTNAME}'..." 1>&2
  sudo hostnamectl set-hostname "${NEWHOSTNAME:-andromeda}"
fi

sudo $RPMPROG update -y

echo ${BASH_VERSION:+-e} "\n\n==> Base packages..."
sudo $RPMPROG install -y curl lftp mosh rsync wget
sudo $RPMPROG install -y less
sudo $RPMPROG install -y p7zip p7zip-plugins lzip cabextract unrar
which tmux >/dev/null 2>&1 || sudo $RPMPROG install -y tmux
sudo $RPMPROG install -y sqlite libdbi-dbd-sqlite
sudo $RPMPROG install -y the_silver_searcher # ag
sudo $RPMPROG install -y unzip zip
sudo $RPMPROG install -y zsh

echo ${BASH_VERSION:+-e} "\n\n==> Devel packages..."

sudo $RPMGROUP -y 'Development Tools'
sudo $RPMPROG install -y ctags
# sudo $RPMPROG install -y golang
sudo $RPMPROG install -y jq
sudo $RPMPROG install -y make
sudo $RPMPROG install -y perl perl-devel perl-ExtUtils-Embed
# sudo $RPMPROG install -y ruby ruby-devel
sudo $RPMPROG install -y tig # git

# #############################################################################
# SELinux

echo ${BASH_VERSION:+-e} "\n\n==> SELinux..."
sudo $RPMPROG install -y setroubleshoot-server selinux-policy-devel

# #############################################################################
# Specific to the distribution

sudo $RPMPROG install -y yum-utils

