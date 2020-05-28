#!/usr/bin/env bash

PROGNAME="setupvscodium.sh"

export VSCODEPKG="codium"

if which "${VSCODEPKG}" >/dev/null 2>&1 ; then
  echo "${PROGNAME:+$PROGNAME: }SKIP: already installed." 1>&2
  exit
fi
echo "$PROGNAME: INFO: started Visual Studio Codium editor setup"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"


export APTPROG=apt-get; which apt >/dev/null 2>&1 && export APTPROG=apt
export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf
export RPMGROUP="yum groupinstall"; which dnf >/dev/null 2>&1 && export RPMGROUP="dnf group install"
export INSTPROG="$APTPROG"; which "$RPMPROG" >/dev/null 2>&1 && export INSTPROG="$RPMPROG"


if egrep -i -q -r 'debian|ubuntu' /etc/*release ; then
  # Add repo
  wget -qO - 'https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg' \
    | sudo apt-key add -
  if ! sudo grep -q "vscodium" /etc/apt/sources.list.d/vscodium.list 2>/dev/null ; then
    echo 'deb https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/repos/debs/ vscodium main' \
      | sudo tee --append /etc/apt/sources.list.d/vscodium.list
  fi
  sudo "${INSTPROG}" update \
    && sudo "${INSTPROG}" install -y apt-transport-https \
    && sudo "${INSTPROG}" install -y "${VSCODEPKG}"


elif egrep -i -q -r 'centos|fedora|oracle|red *hat' /etc/*release ; then
  # Add repo
  printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=gitlab.com_paulcarroty_vscodium_repo\nbaseurl=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/repos/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg" \
    | sudo tee -a /etc/yum.repos.d/vscodium.repo

  sudo "${INSTPROG}" check-update \
    && sudo "${INSTPROG}" install -y "${VSCODEPKG}"
fi


echo "${PROGNAME:+$PROGNAME: }COMPLETE: Visual Studio Codium setup"
echo
echo
