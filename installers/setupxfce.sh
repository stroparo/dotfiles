#!/usr/bin/env bash

# Cristian Stroparo's dotfiles - https://github.com/stroparo/dotfiles

# #############################################################################
# Globals

export APTPROG=apt-get; which apt >/dev/null 2>&1 && export APTPROG=apt
export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf
export RPMGROUP="yum groupinstall"; which dnf >/dev/null 2>&1 && export RPMGROUP="dnf group install"

# #############################################################################
# Main

echo ${BASH_VERSION:+-e} "\n==> XFCE setup..."

# #############################################################################


if egrep -i -q '(centos|fedora|oracle|red *hat)' /etc/*release ; then

  echo ${BASH_VERSION:+-e} "\n==> XFCE dependencies..."

  sudo $RPMGROUP -y "x window system"
  if egrep -i -q '(centos|oracle|red *hat).* 6' /etc/*release ; then
    sudo $RPMGROUP -y desktop "general purpose desktop"
  elif egrep -i -q '(centos|oracle|red *hat).* 7' /etc/*release ; then
    sudo $RPMGROUP -y desktop "server with gui" "mate desktop"
  fi

  sudo $RPMGROUP -y xfce

  echo ${BASH_VERSION:+-e} "\n==> XFCE fonts..."
  sudo $RPMPROG -y install xorg-x11-fonts-Type1 xorg-x11-fonts-misc

  echo ${BASH_VERSION:+-e} "\n==> XFCE Whisker Menu..."

  if egrep -i -q '(centos|oracle|red *hat)' /etc/*release 2>/dev/null ; then

    echo ${BASH_VERSION:+-e} \
      "\n==> CentOS & EL ($RPMPROG install xfce4-whiskermenu-plugin)..."

    sudo $RPMPROG -y install xfce4-whiskermenu-plugin

  elif egrep -i -q 'fedora 2[67]' /etc/*release 2>/dev/null ; then

    echo ${BASH_VERSION:+-e} "\n==> Fedora 26 & 27..."

    fedora_version=$(egrep -i -o 'fedora 2[67]' /etc/*release 2>/dev/null \
      | head -1 \
      | awk '{ print $2; }')

    sudo $RPMPROG remove xfce4-whiskermenu-plugin
    sudo curl -kLSf -o /etc/yum.repos.d/home:gottcode.repo \
      "http://download.opensuse.org/repositories/home:\
  /gottcode/Fedora_${fedora_version}/home:\
  gottcode.repo"
    sudo $RPMPROG install xfce4-whiskermenu-plugin
  fi

# #############################################################################

elif egrep -i -q 'debian|ubuntu' /etc/*release ; then

  sudo $APTPROG install xfce4 desktop-base thunar-volman tango-icon-theme xfce4-notifyd xscreensaver light-locker xfce4-volumed tumbler xfwm4-themes

  echo ${BASH_VERSION:+-e} "\n==> XFCE plugins..."
  sudo $APTPROG install xfce4-clipman-plugin xfce4-mount-plugin xfce4-places-plugin xfce4-terminal xfce4-timer-plugin
fi
