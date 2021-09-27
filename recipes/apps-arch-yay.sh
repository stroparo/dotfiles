#!bin/bash

if ! egrep -i -q -r 'id[^=]*=arch' /etc/*release ; then
  echo "${PROGNAME:+$PROGNAME: }SKIP: Linux Arch only supported." 1>&2
  exit
fi

yay -S brave-bin
yay -S fsearch-git
yay -S openvpn3
