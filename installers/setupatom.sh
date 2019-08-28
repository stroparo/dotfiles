#!/usr/bin/env bash

PROGNAME="setupatom.sh"

if type atom >/dev/null 2>&1 ; then echo "$PROGNAME: SKIP: Already installed" 1>&2 ; exit ; fi

echo "$PROGNAME: INFO: started Atom setup started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

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
# Other distributions

else
  echo "$PROGNAME: SKIP: OS not handled." 1>&2
  exit
fi

# #############################################################################

echo "$PROGNAME: COMPLETE: Atom setup"
exit
