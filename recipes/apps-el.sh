#!/usr/bin/env bash

# Cristian Stroparo's dotfiles
# Custom RPM package selection

PROGNAME=apps-el.sh

# #############################################################################
# Checks

if ! egrep -i -q '(cent ?os|oracle|red ?hat|fedora)' /etc/*release ; then
  echo "${PROGNAME:+$PROGNAME: }SKIP: This is not an Enterprise Linux family instance." 1>&2
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
export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf
export RPMGROUP="yum groupinstall"; which dnf >/dev/null 2>&1 && export RPMGROUP="dnf group install"
export INSTPROG="$RPMPROG"

# #############################################################################
# Helpers

_is_el () { egrep -i -q '(cent ?os|oracle|red ?hat)' /etc/*release ; }
_is_el6 () { egrep -i -q '(cent ?os|oracle|red ?hat).* 6' /etc/*release ; }
_is_el7 () { egrep -i -q '(cent ?os|oracle|red ?hat).* 7' /etc/*release ; }
_is_fedora () { egrep -i -q 'fedora' /etc/*release ; }

_install_packages () {
  for package in "$@" ; do
    echo "Installing '$package'..."
    if ! sudo $INSTPROG install -y "$package" >/tmp/pkg-install-${package}.log 2>&1 ; then
      echo "${PROGNAME:+$PROGNAME: }WARN: There was an error installing package '$package' - see '/tmp/pkg-install-${package}.log'." 1>&2
    fi
  done
}

_install_rpm_groups () {
  for group in "$@" ; do
    echo "Installing RPM group '$group'"
    if ! sudo $RPMGROUP -y "$group" >/tmp/rpm-group-install-err-$group.log 2>&1 ; then
      echo "${PROGNAME:+$PROGNAME: }WARN: There was an error with group '$group' - see '/tmp/rpm-group-install-err-$group.log'." 1>&2
    fi
  done
}

# #############################################################################
# Main

echo "################################################################################"
echo "Enterprise Linux package selects"
echo "################################################################################"

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
_install_packages gnupg pwgen
_install_packages oathtool oath-toolkit

echo "EL security SELinux packages..."
_install_packages setroubleshoot-server selinux-policy-devel

echo "EL system packages..."
_install_packages yum-utils

