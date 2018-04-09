#!/usr/bin/env bash

# Cristian Stroparo's dotfiles - https://github.com/stroparo/dotfiles

# #############################################################################
# Globals

export APTPROG=apt-get; which apt >/dev/null 2>&1 && export APTPROG=apt

# #############################################################################
# Check OS

if ! egrep -i -q 'debian|ubuntu' /etc/*release ; then
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
sudo $APTPROG upgrade -y

# #############################################################################
# Main

echo ${BASH_VERSION:+-e} "\n\n==> Base packages..."
sudo $APTPROG install -y curl lftp mosh net-tools rsync wget
# sudo $APTPROG install -y gdebi-core
sudo $APTPROG install -y less
sudo $APTPROG install -y localepurge
sudo $APTPROG install -y logrotate
sudo $APTPROG install -y parted
sudo $APTPROG install -y p7zip-full p7zip-rar
sudo $APTPROG install -y secure-delete
sudo $APTPROG install -y silversearcher-ag
sudo $APTPROG install -y sqlite3 libdbd-sqlite3
sudo $APTPROG install -y tmux
sudo $APTPROG install -y unzip zip
sudo $APTPROG install -y zsh

echo ${BASH_VERSION:+-e} "\n\n==> Devel packages..."
sudo $APTPROG install -y exuberant-ctags
sudo $APTPROG install -y httpie
sudo $APTPROG install -y git tig
sudo $APTPROG install -y jq
sudo $APTPROG install -y perl libperl-dev
sudo $APTPROG install -y vagrant
# sudo $APTPROG install -y ruby ruby-dev ruby-full

echo ${BASH_VERSION:+-e} "\n\n==> Devel libs..."
sudo $APTPROG install -y gettext
sudo $APTPROG install -y imagemagick
sudo $APTPROG install -y libsqlite3-0 libsqlite3-dev
sudo $APTPROG install -y libssl-dev
sudo $APTPROG install -y zlib1g zlib1g-dev

# #############################################################################
# Cleanup

echo ${BASH_VERSION:+-e} "\n\n==> Cleaning up APT repositories..."

sudo $APTPROG autoremove -y
sudo $APTPROG clean -y
