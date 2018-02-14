#!/usr/bin/env bash

if egrep -i -q '(centos|fedora|oracle|red *hat).* 6' /etc/*release*
  sudo yum groupinstall desktop "general purpose desktop" "x window system"
  sudo yum groupinstall xfce
fi
