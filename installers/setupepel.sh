#!/usr/bin/env bash

PROGNAME="setupepel.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi
if ! egrep -i -q -r 'centos|fedora|oracle|red *hat' /etc/*release ; then echo "${PROGNAME}: SKIP: EL supported only" ; exit ; fi

echo "$PROGNAME: INFO: EPEL repository setup started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

sudo yum install epel-release
# Fallback to manual sequence:
if [ $? -ne 0 ] ; then
  cd /tmp
  wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  ls -l epel*.rpm
  sudo yum install epel-release-latest-7.noarch.rpm
  sudo yum repolist
fi

sudo yum-config-manager --disable epel.repo

echo "${PROGNAME}: WARN: epel disabled by this sequence, to re-enable, run:"
echo "${PROGNAME}:     sudo yum-config-manager --enable epel.repo"
echo "${PROGNAME}:     or use yum's --enablerepo=epel option for each call to yum"
echo "${PROGNAME}:"

echo "${PROGNAME}: COMPLETE: epel repository setup"

exit
