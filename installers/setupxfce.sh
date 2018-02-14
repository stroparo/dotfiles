#!/usr/bin/env bash

if egrep -i -q '(centos|fedora|oracle|red *hat).* 6' /etc/*release*
  yum groupinstall "X Window System" XFCE
  yum groupinstall Desktop "General Purpose Desktop"
fi
