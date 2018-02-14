#!/usr/bin/env bash

if egrep -i -q '(centos|fedora|oracle|red *hat).* 6' /etc/*release*
  yum install xrdp tigervnc-server
fi
