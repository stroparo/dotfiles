#!/usr/bin/env bash

echo
echo "################################################################################"
echo "Setup Git from source"

# #############################################################################
# Globals

VER_FULL=2.18.0
export GIT_PREFIX="/usr/local/git"
export GIT_URL='https://www.kernel.org/pub/software/scm/git/git-${VER_FULL}.tar.gz'
export PROFILE_STRING="export PATH=\"${GIT_PREFIX:-/usr/local/git}/bin:\$PATH\""

# Package installers:
export APTPROG=apt-get; which apt >/dev/null 2>&1 && export APTPROG=apt
export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf

# #############################################################################
# Check OS

if ! (uname -a | grep -i -q linux) ; then
  echo "SKIP: Only Linux is allowed to call this script ($0)" 1>&2
  exit
fi

# #############################################################################
# Main

if egrep -i -q 'centos|fedora|oracle|red *hat' /etc/*release ; then
  sudo bash -c "
$RPMPROG install -y curl-devel expat-devel gettext-devel openssl-devel zlib-devel \
  && $RPMPROG install -y gcc perl-ExtUtils-MakeMaker \
  && cd /usr/src \
  && curl -LSf -o git-${VER_FULL}.tar.gz \"$GIT_URL\" \
  && tar xvzf git-${VER_FULL}.tar.gz \
  && cd git-${VER_FULL} \
  && make prefix=${GIT_PREFIX:-/usr/local/git} all doc info \
  && make prefix=${GIT_PREFIX:-/usr/local/git} install install-doc install-html install-info
"
  # TODO add update-alternativas logic as well as manpages slaves
elif egrep -i -q 'debian|ubuntu' /etc/*release ; then
  : # TODO implement
fi

# #############################################################################
# Post installation

if [ ! -f /etc/profile.d/gitsrc.sh ] ; then
  echo "${PROFILE_STRING}" | sudo tee /etc/profile.d/gitsrc.sh > /dev/null
  sudo chmod 755 /etc/profile.d/gitsrc.sh
fi

echo "${PROGNAME:+$PROGNAME: }INFO: Git path:" 1>&2
eval ${PROFILE_STRING}
which -a git
git --version

# #############################################################################
# Finish

echo "FINISHED Git from source setup"
echo
