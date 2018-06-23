#!/usr/bin/env bash

# Cristian Stroparo's dotfiles
# Custom RPM package selection

# #############################################################################
# Globals

PROGNAME=rpmselects.sh

# System installers
export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf
export RPMGROUP="yum groupinstall"; which dnf >/dev/null 2>&1 && export RPMGROUP="dnf group install"
export INSTPROG="$RPMPROG"

# #############################################################################
# Helpers

_is_el_family () { egrep -i -q '(cent ?os|oracle|red ?hat|fedora)' /etc/*release ; }
_is_el () { egrep -i -q '(cent ?os|oracle|red ?hat)' /etc/*release ; }
_is_el6 () { egrep -i -q '(cent ?os|oracle|red ?hat).* 6' /etc/*release ; }
_is_el7 () { egrep -i -q '(cent ?os|oracle|red ?hat).* 7' /etc/*release ; }
_is_fedora () { egrep -i -q 'fedora' /etc/*release ; }

_install_packages () {
  for package in "$@" ; do
    echo "Installing '$package'..."
    if ! sudo $INSTPROG install -y "$package" >/dev/null 2>/tmp/pkg-install-${package}.log ; then
      echo "${PROGNAME:+$PROGNAME: }WARN: There was an error installing package '$package' - see '/tmp/pkg-install-${package}.log'." 1>&2
    fi
  done
}

_install_rpm_groups () {
  for group in "$@" ; do
    echo "Installing RPM group '$group'"
    if ! sudo $RPMGROUP -y "$group" >/dev/null 2>/tmp/rpm-group-install-err-$group.log ; then
      echo "${PROGNAME:+$PROGNAME: }WARN: There was an error with group '$group' - see '/tmp/rpm-group-install-err-$group.log'." 1>&2
    fi
  done
}

_print_bar () {
  echo "################################################################################"
}

_print_header () {
  _print_bar
  echo "$@"
  _print_bar
}

# #############################################################################
# Checks

if ! _is_el_family ; then
  echo "FATAL: Only Enterprise Linux family allowed to call this script ($0)" 1>&2
  exit 1
fi

if ! which sudo >/dev/null 2>&1 ; then
  echo "FATAL: Please log in as root, install and then configure sudo for your user first.." 1>&2
  cat "Suggested commands:" <<EOF
su -
$RPMPROG install sudo
visudo
EOF
  exit 1
fi

# #############################################################################
# Main

_print_header "Enterprise Linux package selects"

# EPEL extra packages
if ! _is_fedora ; then
  echo "EPEL - Extra Packages for Enterprise Linux..." # https://fedoraproject.org/wiki/EPEL
  if _is_el7 ; then
    _install_packages https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  else
    _install_packages epel-release.noarch
  fi
fi

# New HOSTNAME setup, if any
if [ -n "$NEWHOSTNAME" ] ; then
  echo "==> Setting up hostname to '${NEWHOSTNAME}'..." 1>&2
  sudo hostnamectl set-hostname "${NEWHOSTNAME:-andromeda}"
fi

# Package indexing setup
sudo yum makecache fast

echo "EL base packages..."
_install_packages curl lftp rsync wget
_install_packages --enablerepo=epel mosh
_install_packages less
_install_packages --enablerepo=epel p7zip p7zip-plugins lzip cabextract unrar
which tmux >/dev/null 2>&1 || _install_packages tmux
_install_packages sqlite libdbi-dbd-sqlite
_install_packages --enablerepo=epel the_silver_searcher # ag
_install_packages unzip zip
_install_packages zsh

echo "EL devel packages..."

sudo $RPMGROUP -q -y --enablerepo=epel 'Development Tools'
_install_packages ctags
# _install_packages golang
_install_packages --enablerepo=epel jq
_install_packages make
_install_packages perl perl-devel perl-ExtUtils-Embed
# _install_packages ruby ruby-devel
_install_packages --enablerepo=epel tig # git

echo "EL security packages..."
sudo $INSTPROG install -q -y gnupg pwgen
sudo $INSTPROG install -q -y oathtool oath-toolkit

echo "EL security SELinux packages..."
_install_packages setroubleshoot-server selinux-policy-devel

echo "EL system packages..."
_install_packages yum-utils

