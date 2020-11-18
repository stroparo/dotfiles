#!/bin/sh

PROGNAME="apps-debian.sh"
export APTPROG=apt-get
export INSTPROG=apt-get

if ! egrep -i -q -r 'debi|ubun' /etc/*release ; then echo "PROGNAME: SKIP: De/b/untu-like supported only" ; exit ; fi

echo "$PROGNAME: INFO: Debian package selections installation"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"


_install_packages () {
  for package in "$@" ; do
    if dpkg -s "${package}" >/dev/null 2>&1 ; then
      echo "$PROGNAME: SKIP: Package '${package}' already installed..."
    else
      echo "$PROGNAME: INFO: Installing '${package}'..."
      if ! (sudo "${INSTPROG}" install -y "${package}" 2>&1 | tee "/tmp/pkg-install-${package}.log") ; then
        echo "$PROGNAME: WARN: There was an error installing package '${package}' - see '/tmp/pkg-install-${package}.log'." 1>&2
      fi
    fi
  done
}


# #############################################################################
echo "$PROGNAME: INFO: Debian APT index update..."

if ! sudo $APTPROG update >/dev/null 2>/tmp/apt-update-err.log ; then
  echo "$PROGNAME: WARN: There was some failure during APT index update - see '/tmp/apt-update-err.log'." 1>&2
fi

# #############################################################################
# Installations

echo "$PROGNAME: INFO: Debian base packages..."
_install_packages bash
_install_packages curl lftp mosh net-tools rsync wget
_install_packages dconf-cli
_install_packages gdebi gdebi-core
_install_packages hashdeep
_install_packages htop
_install_packages less
_install_packages localepurge
_install_packages logrotate
_install_packages parted
_install_packages p7zip-full p7zip-rar
_install_packages secure-delete
_install_packages silversearcher-ag
_install_packages tmux
_install_packages unzip zip
_install_packages xz-utils
_install_packages zsh

echo "$PROGNAME: INFO: Debian devel packages..."
_install_packages automake build-essential gcc make
_install_packages bison
_install_packages exuberant-ctags
_install_packages git tig
_install_packages httpie
_install_packages jq
_install_packages llvm
_install_packages mongodb
_install_packages perl
_install_packages pkg-config
_install_packages redis-server
# _install_packages python-software-properties
_install_packages sqlite3 libdbd-sqlite3

echo "$PROGNAME: INFO: Debian devel libs..."
_install_packages gettext
_install_packages imagemagick
_install_packages libbz2-dev
_install_packages libcurl4-openssl-dev
_install_packages libffi-dev
_install_packages libgdbm-dev
_install_packages libgmp-dev
_install_packages liblzma-dev
_install_packages libncurses5-dev libncursesw5-dev
_install_packages libperl-dev
_install_packages libreadline-dev
_install_packages libsqlite3-0 libsqlite3-dev
_install_packages libssl-dev
_install_packages libxml2-dev
_install_packages libxslt1-dev
_install_packages libyaml-dev
_install_packages python-openssl
_install_packages tk-dev
_install_packages zlib1g zlib1g-dev

echo "$PROGNAME: INFO: Debian security packages..."
_install_packages gnupg pwgen
_install_packages oathtool
_install_packages ssh-askpass

# #############################################################################
# Cleanup

echo "$PROGNAME: INFO: Debian APT repository clean up..."
sudo $APTPROG autoremove -y
sudo $APTPROG clean -y

# #############################################################################
# Final sequence

echo "$PROGNAME: COMPLETE: Debian package selections installation"
exit
