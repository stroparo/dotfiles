#!/usr/bin/env bash

PROGNAME=setupepel.sh

echo
echo "################################################################################"
echo "Setup EPEL repository..."

# #############################################################################
# Checks

# Check for idempotency
if ! egrep -i -q 'centos|fedora|oracle|red *hat' /etc/*release ; then
  echo "${PROGNAME}: SKIP: Only Enterprise Linux distributions are supported." 1>&2
  exit
fi

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

# #############################################################################
# Finish

echo "${PROGNAME}: FINISHED epel repository setup"
