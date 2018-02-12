#!/usr/bin/env bash

# Daily Shells Extras extensions
# More instructions and licensing at:
# https://github.com/stroparo/ds-extras

# Remove Vim from the system

# #############################################################################
# Globals

PURGE=false
USAGE="[-p] option purges any config files remaining"

# #############################################################################
# Options

OPTIND=1
while getopts ':hp' option ; do
  case "${option}" in
    h) echo "$USAGE"; exit;;
    p) PURGE=true;;
  esac
done
shift "$((OPTIND-1))"

# #############################################################################

# Remove Vim from the system

if egrep -i -q 'debian|ubuntu' /etc/*release* ; then

  sudo apt remove -y --purge vim vim-runtime vim-gnome vim-tiny vim-gui-common

elif egrep -i -q 'centos|fedora|oracle|red *hat' /etc/*release* ; then

  sudo yum -y remove vim-enhanced
fi

sudo rm -rf /usr/local/share/vim /usr/bin/vim

# #############################################################################
# Purge

if ${PURGE:-false} ; then

  if egrep -i -q 'centos|fedora|oracle|red *hat' /etc/*release* ; then

    for file in $(rpm -q --configfiles vim-enhanced)
    do
      echo "  removing $file"
      rm -f $file
    done
    rpm -e vim-enhanced
  fi
fi

# #############################################################################
