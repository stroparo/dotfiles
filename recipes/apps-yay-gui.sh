#!bin/bash

if ! egrep -i -q -r 'id[^=]*=arch' /etc/*release ; then
  echo "${PROGNAME:+$PROGNAME: }SKIP: Linux Arch only supported." 1>&2
  exit
fi


if ! (which caja >/dev/null 2>&1 \
  || which dolphin >/dev/null 2>&1 \
  || which nautilus >/dev/null 2>&1 \
  || which nemo >/dev/null 2>&1 \
  || which pcmanfm >/dev/null 2>&1 \
  || which thunar >/dev/null 2>&1 \
  || sudo systemctl status gdm \
  || sudo systemctl status lightdm \
  || sudo systemctl status lxdm \
  || sudo systemctl status sddm \
  )
then
  echo "$PROGNAME: SKIP: No Display Manager, so no GUI available."
  exit
fi


PKGLIST="
brave-bin
fsearch-git
insomnia
skypeforlinux-stable-bin
slack-desktop
"

yay -S --ignore --noconfirm $(echo ${PKGLIST})
