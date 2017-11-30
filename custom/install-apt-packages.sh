#!/usr/bin/env bash

# ##############################################################################
# Check OS

if ! egrep -i -q 'debian|ubuntu' /etc/*release* ; then
  echo "FATAL: Only Debian/Ubuntu based distros are allowed to call this script ($0)" 1>&2
  exit 1
fi

# ##############################################################################
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

# ##############################################################################
sudo apt update

# ##############################################################################
# Upgrade

echo ${BASH_VERSION:+-e} "\n==> Upgrade all packages? [y/N]\c" ; read answer
[[ $answer = y ]] && sudo apt upgrade

# ##############################################################################
# Base

echo ${BASH_VERSION:+-e} "\n==> Base packages..."
sudo apt install -y curl less rsync unzip wget zip zsh

# Etc
sudo apt install -y gdebi-core
sudo apt install -y localepurge logrotate net-tools parted secure-delete silversearcher-ag
sudo apt install -y lftp mosh
sudo apt install -y p7zip-full

# ##############################################################################
# Devel

sudo apt install -y exuberant-ctags git tig httpie jq make sqlite3 tmux vim vim-scripts

echo ${BASH_VERSION:+-e} "\n==> Libs? [Y/n]\c" ; read answer
if [[ $answer != n ]] ; then
  sudo apt install gettext imagemagick libsqlite3-0 libsqlite3-dev zlib1g zlib1g-dev
fi

echo ${BASH_VERSION:+-e} "\n==> Python? [y/N]\c" ; read answer
if [[ $answer = y ]] ; then
  sudo apt install python-dev python-pip python3-dev python3-pip
fi

# ##############################################################################
# Cleanup

sudo apt autoremove
sudo apt clean
