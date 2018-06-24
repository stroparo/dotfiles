#!/usr/bin/env bash

# Cristian Stroparo's dotfiles
# Custom Debian package selection

PROGNAME=apps-debian.sh

# #############################################################################
# Checks

if ! egrep -i -q 'debian|ubuntu' /etc/*release ; then
  echo "${PROGNAME:+$PROGNAME: }SKIP: This is not an Debian/Ubuntu Linux family instance." 1>&2
  exit
fi

if ! which sudo >/dev/null 2>&1 ; then
  echo "${PROGNAME:+$PROGNAME: }WARN: Installing sudo via root and opening up visudo" 1>&2
  su - -c "bash -c '$INSTPROG install sudo; visudo'"
fi
if ! sudo whoami >/dev/null 2>&1 ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: No sudo access." 1>&2
  exit 1
fi

# #############################################################################
# Globals

# System installers
export APTPROG=apt-get; which apt >/dev/null 2>&1 && export APTPROG=apt
export INSTPROG="$APTPROG"

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

# #############################################################################
# Main

echo "################################################################################"
echo "Debian package selects"
echo "################################################################################"

echo "Debian APT index update..."
if ! sudo $APTPROG update >/dev/null 2>/tmp/apt-update-err.log ; then
  echo "WARN: There was some failure during APT index update - see '/tmp/apt-update-err.log'." 1>&2
fi

echo "Debian base packages..."
_install_packages curl lftp mosh net-tools rsync wget
# _install_packages gdebi-core
_install_packages less
_install_packages localepurge
_install_packages logrotate
_install_packages parted
_install_packages p7zip-full p7zip-rar
_install_packages secure-delete
_install_packages silversearcher-ag
_install_packages sqlite3 libdbd-sqlite3
_install_packages tmux
_install_packages unzip zip
_install_packages zsh

echo "Debian devel packages..."
_install_packages exuberant-ctags
_install_packages httpie
_install_packages git tig
_install_packages jq
_install_packages perl libperl-dev
# _install_packages ruby ruby-dev ruby-full

echo "Debian devel libs..."
_install_packages gettext
_install_packages imagemagick
_install_packages libsqlite3-0 libsqlite3-dev
_install_packages libssl-dev
_install_packages zlib1g zlib1g-dev

echo "Debian security packages..."
_install_packages gnupg pwgen
_install_packages oathtool

# #############################################################################
# Cleanup

echo "Debian APT repository clean up..."
sudo $APTPROG autoremove -y
sudo $APTPROG clean -y
