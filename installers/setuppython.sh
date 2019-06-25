#!/usr/bin/env bash

echo
echo "################################################################################"
echo "Setup Python"

# #############################################################################
# Globals

export PROGNAME=setuppython.sh

export APTPROG=apt-get; which apt >/dev/null 2>&1 && export APTPROG=apt
export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf

# #############################################################################
# Check OS

if ! egrep -i -q -r 'debian|ubuntu|centos|fedora|oracle|red *hat' /etc/*release ; then
  echo "$PROGNAME: SKIP: Only Debian and Enterprise Linux distributions are supported." 1>&2
  exit
fi

# #############################################################################
# Shell

[ -n "$ZSH_VERSION" ] && set -o shwordsplit

# #############################################################################
echo ${BASH_VERSION:+-e} "\n\n==> Python system packages"

if egrep -i -q -r 'debian|ubuntu' /etc/*release ; then

  sudo $APTPROG update || exit $?

  # Distribution Python
  sudo $APTPROG install -y python python-dev python-pip
  sudo $APTPROG install -y python3 python3-dev python3-pip

  # pyenv dependencies
  sudo $APTPROG install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
  libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
  xz-utils tk-dev

  # tools
  which git >/dev/null 2>&1 || sudo $APTPROG install -y git-core || exit $?
  which sqlite3 >/dev/null 2>&1 || sudo $APTPROG install -y sqlite3 || exit $?

elif egrep -i -q -r 'centos|fedora|oracle|red *hat' /etc/*release ; then

  # Python 2
  sudo $RPMPROG install -q -y --enablerepo=epel python python-devel
  sudo $RPMPROG install -q -y --enablerepo=epel python-pip \
    || sudo $RPMPROG install -q -y --enablerepo=epel python2-pip

  # Python 3
  sudo $RPMPROG install -q -y --enablerepo=epel python3 python3-devel \
    || sudo $RPMPROG install -q -y --enablerepo=epel python34 python34-devel
  sudo $RPMPROG install -q -y --enablerepo=epel python3-pip \
    || sudo $RPMPROG install -q -y --enablerepo=epel python34-pip

  # pyenv dependencies
  sudo $RPMPROG install -q -y --enablerepo=epel zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel xz xz-devel

  # tools
  which git >/dev/null 2>&1 || sudo $RPMPROG install -q -y git || exit $?
  which sqlite >/dev/null 2>&1 || sudo $RPMPROG install -q -y sqlite || exit $?
fi

(
echo ${BASH_VERSION:+-e} "\n\n==> pip upgrade for system's pip, so no pyenv in PATH...\n"
export PATH="$(echo "$PATH" | tr : \\n | grep -v pyenv | tr \\n :)"
sudo -H pip install --upgrade pip
sudo -H pip3 install --upgrade pip
)

# #############################################################################
# Finish

echo "FINISHED Python setup"
echo
