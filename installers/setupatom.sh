#!/usr/bin/env bash

# Cristian Stroparo's dotfiles - https://github.com/stroparo/dotfiles

echo ${BASH_VERSION:+-e} '\n\n==> Installing atom...' 1>&2

# #############################################################################
# Checks

# Check for idempotency
if type atom >/dev/null 2>&1 ; then
  echo "SKIP: Already installed." 1>&2
  exit
fi

# #############################################################################
# Cygwin

if [[ "$(uname -a)" = *[Cc]ygwin* ]] ; then

  wget 'https://atom.io/download/windows'
  mv windows atomsetup.exe
  chmod u+x atomsetup.exe && ./atomsetup.exe && rm -f ./atomsetup.exe

# #############################################################################
# Debian/Ubuntu

elif egrep -i -q 'debian|ubuntu' /etc/*release ; then

  wget 'https://atom.io/download/deb'
  sudo dpkg -i deb && rm -f deb

# #############################################################################
# Red Hat family

elif egrep -i -q 'centos|fedora|oracle|red *hat' /etc/*release ; then

  wget 'https://atom.io/download/rpm'
  sudo rpm -ivh rpm && rm -f rpm

# #############################################################################

else
  echo "FATAL: OS not handled." 1>&2
  exit 1
fi
