#!/usr/bin/env bash

PROGNAME="setupvscodium.sh"
export PKGNAME="codium"
export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf
if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi
if which "${PKGNAME}" >/dev/null 2>&1 ; then echo "$PROGNAME: SKIP: already installed." ; exit ; fi


echo "$PROGNAME: INFO: setup started..."
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"


if egrep -i -q -r 'debian|ubuntu' /etc/*release ; then

  wget -qO - 'https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg' \
    | gpg --dearmor \
    | sudo dd of=/etc/apt/trusted.gpg.d/vscodium.gpg

  if ! sudo grep -q "vscodium" /etc/apt/sources.list.d/vscodium.list 2>/dev/null ; then
    echo 'deb https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs/ vscodium main' \
      | sudo tee --append /etc/apt/sources.list.d/vscodium.list
  fi
  sudo apt-get update
  sudo apt-get install -y apt-transport-https
  sudo apt-get install -y "${PKGNAME}"


elif egrep -i -q -r 'centos|fedora|oracle|red *hat' /etc/*release ; then
  printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=gitlab.com_paulcarroty_vscodium_repo\nbaseurl=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/repos/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg" \
    | sudo tee -a /etc/yum.repos.d/vscodium.repo
  sudo "${RPMPROG}" check-update \
    && sudo "${RPMPROG}" install -y "${PKGNAME}"
fi


echo "${PROGNAME:+$PROGNAME: }COMPLETE"
echo
echo
