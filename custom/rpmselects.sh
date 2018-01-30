#!/usr/bin/env bash

# #############################################################################
# Globals

export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf

# #############################################################################
# Check OS

if ! egrep -i -q 'cent ?os|fedora|oracle|red ?hat' /etc/*release* ; then
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
# Update

echo ${BASH_VERSION:+-e} "\n\n==> Updating..."
echo ${BASH_VERSION:+-e} "==> Upgrade all packages? [y/N]\c" ; read answer
[[ $answer = y ]] && sudo $RPMPROG update

# #############################################################################
# Base

echo ${BASH_VERSION:+-e} "\n\n==> Base packages..."

sudo $RPMPROG install -y curl less rsync unzip wget zip zsh
sudo $RPMPROG install -y lftp mosh
sudo $RPMPROG install -y p7zip p7zip-plugins

# #############################################################################
# EPEL (Extra Packages for Enterprise Linux)
# https://fedoraproject.org/wiki/EPEL

echo ${BASH_VERSION:+-e} \
  "\n\n==> EPEL (Extra Packages for Enterprise Linux)..."

if ! grep -i -q 'fedora' /etc/*release* ; then
  sudo $RPMPROG install -y epel-release.noarch
fi

# #############################################################################
# Devel

echo ${BASH_VERSION:+-e} "\n\n==> Devel packages..."

sudo $RPMPROG install -y git tig jq make sqlite tmux
sudo $RPMPROG -y groupinstall 'Development Tools'

echo ${BASH_VERSION:+-e} "\n\n==> Devel libs? [Y/n]\c"
read answer
if [[ $answer != n ]] ; then
  sudo $RPMPROG install -y ncurses ncurses-devel
fi

echo ${BASH_VERSION:+-e} "\n\n==> Go Programming Language (golang)? [y/N]\c"
read answer
if [[ $answer = y ]] ; then
  sudo $RPMPROG install -y golang
fi

echo ${BASH_VERSION:+-e} "\n\n==> Nodejs? [y/N]\c"
read answer
if [[ $answer = y ]] ; then
  curl --silent --location https://rpm.nodesource.com/setup_8.x | bash -
  sudo $RPMPROG install -y nodejs
  npm install -g typescript
fi

echo ${BASH_VERSION:+-e} "\n\n==> Perl distribution packages? [y/N]\c"
read answer
if [[ $answer = y ]] ; then
  sudo $RPMPROG install -y perl perl-devel perl-ExtUtils-Embed
fi

echo ${BASH_VERSION:+-e} "\n\n==> Python(2) distribution packages? [y/N]\c"
read answer
if [[ $answer = y ]] ; then
  sudo $RPMPROG install -y python python-devel
fi

echo ${BASH_VERSION:+-e} "\n\n==> Ruby distribution packages? [y/N]\c"
read answer
if [[ $answer = y ]] ; then
  sudo $RPMPROG install -y ruby ruby-devel
fi

# #############################################################################
# SELinux

sudo $RPMPROG install -y setroubleshoot-server selinux-policy-devel

# #############################################################################
# SilverSearcher Ag
# https://github.com/ggreer/the_silver_searcher

if ! ag --version ; then
  # Must have the epel-release repository:
  sudo $RPMPROG install -y the_silver_searcher
fi

# #############################################################################
# Specific to the distribution

sudo $RPMPROG install -y yum-utils

# #############################################################################
# Cleanup

