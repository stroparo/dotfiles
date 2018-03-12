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
# Routines

_is_interactive () { [[ $- = *i* ]] ; }

_user_confirm () {
  # Info: Ask a question and yield success if user responded [yY]*

  typeset confirm
  typeset result=1

  echo ${BASH_VERSION:+-e} "$@" "[y/N] \c"
  read confirm
  if [[ $confirm = [yY]* ]] ; then return 0 ; fi
  return 1
}

# #############################################################################
# Hostname

if _is_interactive ; then
  echo
  if _user_confirm "==> Set custom hostname?" ; then
    echo ${BASH_VERSION:+-e} "Hostname: \c" ; read newhostname
    sudo hostnamectl set-hostname "${newhostname:-andromeda}"
  fi
fi

# #############################################################################
# Update

echo ${BASH_VERSION:+-e} "\n\n==> Updating..."
if _user_confirm "==> Upgrade all packages?" ; then
  sudo $RPMPROG update -y
fi

# #############################################################################
# EPEL (Extra Packages for Enterprise Linux)
# https://fedoraproject.org/wiki/EPEL

echo ${BASH_VERSION:+-e} \
  "\n\n==> EPEL (Extra Packages for Enterprise Linux)..."

if ! grep -i -q 'fedora' /etc/*release* ; then
  if egrep -i -q '(centos|oracle|red *hat).* 7' /etc/*release* ; then
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

echo ${BASH_VERSION:+-e} "\n\n==> Base packages..."
sudo $RPMPROG install -y curl lftp mosh rsync wget
sudo $RPMPROG install -y less
sudo $RPMPROG install -y p7zip p7zip-plugins lzip cabextract unrar
which tmux >/dev/null 2>&1 || sudo $RPMPROG install -y tmux
sudo $RPMPROG install -y sqlite libdbi-dbd-sqlite
sudo $RPMPROG install -y unzip zip
sudo $RPMPROG install -y zsh

echo ${BASH_VERSION:+-e} "\n\n==> Devel packages..."

(which git 2>/dev/null | grep -q /opt) && IS_GIT_OPT=true
sudo $RPMGROUP -y 'Development Tools'
${IS_GIT_OPT:-false} && sudo $RPMPROG remove -y git

sudo $RPMPROG install -y ctags
sudo $RPMPROG install -y jq
sudo $RPMPROG install -y make
if ${IS_GIT_OPT:-false} ; then
  : # TODO implement tig installation from latest/source
else
  sudo $RPMPROG install -y tig
fi

echo ${BASH_VERSION:+-e} "\n\n==> Devel libs? (often needed for compiling) [Y/n]\c"
read answer
if [[ $answer != n ]] ; then
  sudo $RPMPROG install -y libevent libevent-devel libevent-headers
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

echo ${BASH_VERSION:+-e} "\n\n==> Python3 distribution packages? [y/N]\c"
read answer
if [[ $answer = y ]] ; then
  sudo $RPMPROG install -y python3 python3-devel
fi

echo ${BASH_VERSION:+-e} "\n\n==> Ruby distribution packages? [y/N]\c"
read answer
if [[ $answer = y ]] ; then
  sudo $RPMPROG install -y ruby ruby-devel
fi

# #############################################################################
# SELinux

echo ${BASH_VERSION:+-e} "\n\n==> SELinux..."
sudo $RPMPROG install -y setroubleshoot-server selinux-policy-devel

# #############################################################################
# SilverSearcher Ag
# https://github.com/ggreer/the_silver_searcher

if ! ag --version ; then
  # Must have the epel-release repository:
  echo ${BASH_VERSION:+-e} "\n\n==> SilverSearcher Ag..."
  sudo $RPMPROG install -y the_silver_searcher
fi

# #############################################################################
# Specific to the distribution

sudo $RPMPROG install -y yum-utils

# #############################################################################
# Cleanup

