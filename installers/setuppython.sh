#!/usr/bin/env bash

PROGNAME="setuppython.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi

echo "$PROGNAME: INFO: Python system-wide setup started..."
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Globals

export APTPROG=apt-get; which apt >/dev/null 2>&1 && export APTPROG=apt
export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf

# #############################################################################
# Shell

[ -n "$ZSH_VERSION" ] && set -o shwordsplit

# #############################################################################
echo ${BASH_VERSION:+-e} "\n\n==> Python system-wide packages"

if egrep -i -q -r 'debian|ubuntu' /etc/*release ; then

  sudo $APTPROG update || exit $?

  sudo $APTPROG install -y make
  
  # Python 2, maintain these in case Py 3 packages switch to just "python":
  sudo $APTPROG install -y python python-pip python-dev

  # Python 3
  sudo $APTPROG install -y python3 python3-pip python3-dev
  sudo $APTPROG install -y build-essential libssl-dev zlib1g-dev libbz2-dev \
  libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
  xz-utils tk-dev libffi-dev liblzma-dev python-openssl git

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
# Final sequence

echo "$PROGNAME: COMPLETE: Python setup"
exit
