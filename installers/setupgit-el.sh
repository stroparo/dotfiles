#!/usr/bin/env bash

echo
echo "################################################################################"
echo "Setup Git for EL Enterprise Linux based distributions"

# #############################################################################
# Globals

VER_FULL=2.15.0
URL_GIT='https://www.kernel.org/pub/software/scm/git/git-${VER_FULL}.tar.gz'
export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf

# #############################################################################
# Check OS

if ! egrep -i -q 'cent ?os|fedora|oracle|red ?hat' /etc/*release ; then
  echo "SKIP: Only Red Hat based distros are allowed to call this script ($0)" 1>&2
  exit
fi

# #############################################################################
# Pre-requisites

if $UID != 0 ; then
  echo "SKIP: Must run this as root" 1>&2
  exit
fi

# #############################################################################

$RPMPROG install -y curl-devel expat-devel gettext-devel openssl-devel zlib-devel \
  && $RPMPROG install -y gcc perl-ExtUtils-MakeMaker \
  && cd /usr/src \
  && curl -o git-${VER_FULL}.tar.gz "$URL_GIT" \
  && tar xvzf git-${VER_FULL}.tar.gz \
  && cd git-${VER_FULL} \
  && make prefix=/usr/local/git all \
  && make prefix=/usr/local/git install

# TODO: add update-alternativas logic as well as manpages slaves

if ! grep -q '/git' /etc/bashrc ; then
  echo "export PATH=/usr/local/git/bin:$PATH" >> /etc/bashrc
  export PATH=/usr/local/git/bin:$PATH
fi

git --version

# #############################################################################
# Finish

echo "FINISHED Git for EL setup"
echo
