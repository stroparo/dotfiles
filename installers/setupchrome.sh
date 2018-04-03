#!/usr/bin/env bash

# Cristian Stroparo's dotfiles - https://github.com/stroparo/dotfiles

# #############################################################################
# Globals

export APTPROG=apt-get; which apt >/dev/null 2>&1 && export APTPROG=apt
export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf
export RPMGROUP="yum groupinstall"; which dnf >/dev/null 2>&1 && export RPMGROUP="dnf group install"

# #############################################################################
# Main

echo ${BASH_VERSION:+-e} "\n==> Setting up Google Chrome..."

if egrep -i -q '(centos|fedora|oracle|red *hat).* 7' /etc/*release ; then

  cat <<EOF | sudo tee /etc/yum.repos.d/google-x86_64.repo
[google64]
name=Google - x86_64
baseurl=http://dl.google.com/linux/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
EOF
  sudo $RPMPROG install -y google-chrome-stable

elif egrep -i -q 'debian|ubuntu' /etc/*release ; then

  echo "SKIP: Debian/Ubuntu to be implemented" 1>&2

fi
