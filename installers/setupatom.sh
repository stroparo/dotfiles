#!/usr/bin/env bash

echo
echo "################################################################################"
echo "Setup Atom editor..."

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

elif egrep -i -q -r 'debian|ubuntu' /etc/*release ; then

  wget -O "$HOME"/atom.deb 'https://atom.io/download/deb'
  sudo dpkg -i "$HOME"/atom.deb && rm -f "$HOME"/atom.deb

# #############################################################################
# Red Hat family

elif egrep -i -q -r 'centos|fedora|oracle|red *hat' /etc/*release ; then

  wget -O "$HOME"/atom.rpm 'https://atom.io/download/rpm'
  sudo yum-config-manager --enable epel.repo
  sudo rpm -ivh "$HOME"/atom.rpm && rm -f "$HOME"/atom.rpm
  sudo yum-config-manager --disable epel.repo

# #############################################################################

else
  echo "SKIP: OS not handled." 1>&2
  exit
fi

# #############################################################################
# Finish

echo "FINISHED Atom setup"
echo
