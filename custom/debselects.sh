#!/usr/bin/env bash

# #############################################################################
# Globals

export APTPROG=apt-get; which apt >/dev/null 2>&1 && export APTPROG=apt

# #############################################################################
# Check OS

if ! egrep -i -q 'debian|ubuntu' /etc/*release* ; then
  echo "FATAL: Only Debian/Ubuntu based distros are allowed to call this script ($0)" 1>&2
  exit 1
fi

# #############################################################################
# Sudo check

if ! which sudo ; then
  echo "FATAL: Please log in as root, install and then configure sudo for your user first.." 1>&2
  cat "Suggested commands:" <<EOF
su -
apt update && apt install -y sudo
visudo
EOF
  exit 1
fi

# #############################################################################
# Update

echo ${BASH_VERSION:+-e} "\n\n==> Updating..."

sudo $APTPROG update

echo ${BASH_VERSION:+-e} "\n\n==> Upgrade all packages? [y/N]\c"
read answer
[[ $answer = y ]] && sudo $APTPROG upgrade

# #############################################################################
# Base

echo ${BASH_VERSION:+-e} "\n\n==> Base packages..."

sudo $APTPROG install -y curl less p7zip-full parted rsync silversearcher-ag tmux unzip wget zip zsh
sudo $APTPROG install -y lftp mosh net-tools

# Etcetera
sudo $APTPROG install -y gdebi-core
sudo $APTPROG install -y localepurge
sudo $APTPROG install -y logrotate
sudo $APTPROG install -y secure-delete

# #############################################################################
# Devel

echo ${BASH_VERSION:+-e} "\n\n==> Devel packages..."

sudo $APTPROG install -y exuberant-ctags git tig httpie jq make sqlite3

echo ${BASH_VERSION:+-e} "\n\n==> Devel libs? [Y/n]\c"
read answer
if [[ $answer != n ]] ; then
  sudo $APTPROG install -y gettext
  sudo $APTPROG install -y imagemagick
  sudo $APTPROG install -y libsqlite3-0 libsqlite3-dev
  sudo $APTPROG install -y zlib1g zlib1g-dev
fi

echo ${BASH_VERSION:+-e} "\n\n==> Perl distribution packages? [y/N]\c"
read answer
if [[ $answer = y ]] ; then
  sudo $APTPROG install -y perl libperl-dev
fi

echo ${BASH_VERSION:+-e} "\n\n==> Python distribution packages? [y/N]\c"
read answer
if [[ $answer = y ]] ; then
  sudo $APTPROG install -y python-dev python-pip
  sudo $APTPROG install -y python3-dev python3-pip
fi

echo ${BASH_VERSION:+-e} "\n\n==> Ruby distribution packages? [y/N]\c"
read answer
if [[ $answer = y ]] ; then
  sudo $APTPROG install -y ruby ruby-dev ruby-full
fi

# #############################################################################
# Cleanup

echo ${BASH_VERSION:+-e} "\n\n==> Cleaning up APT repositories..."

sudo $APTPROG autoremove
sudo $APTPROG clean
