#!/usr/bin/env bash

if egrep -i -q '(centos|fedora|oracle|red *hat).* 6' /etc/*release*
  sudo yum -y install xrdp tigervnc-server
fi
