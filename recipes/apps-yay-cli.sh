#!bin/bash

if ! egrep -i -q -r 'id[^=]*=arch' /etc/*release ; then
  echo "${PROGNAME:+$PROGNAME: }SKIP: Linux Arch only supported." 1>&2
  exit
fi

PKGLIST="
openvpn3
"

yay -S --ignore --noconfirm $(echo ${PKGLIST})
