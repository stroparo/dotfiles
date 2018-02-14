#!/usr/bin/env bash

if egrep -i -q '(centos|fedora|oracle|red *hat).* 6' /etc/*release*
  sudo yum groupinstall desktop "general purpose desktop" "x window system"
  sudo yum groupinstall xfce
  sudo yum -y install xorg-x11-fonts-Type1 xorg-x11-fonts-misc
fi
