#!/usr/bin/env bash

# Cristian Stroparo's dotfiles - https://github.com/stroparo/dotfiles

# OpenShift installer for Enterprise Linux 7

set -e
PROGNAME=setupopenshift-el7.sh
VG_NAME=docker-vg

# #############################################################################
# Checks

if ! egrep -i -q 'red *hat.* 7' /etc/*release ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: Only EL7 supported." 1>&2
fi

if [ "$(id -u)" -ne 0 ]; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: Must be root." 1>&2
fi

# #############################################################################
echo "${PROGNAME:+$PROGNAME: }INFO: Installing dependencies..." 1>&2
yum update -y
yum install -y wget git net-tools bind-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct
yum -y install \
    https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sed -i -e "s/^enabled=1/enabled=0/" /etc/yum.repos.d/epel.repo
yum -y --enablerepo=epel install ansible pyOpenSSL

# #############################################################################
echo "${PROGNAME:+$PROGNAME: }INFO: Prep containerized installation..." 1>&2

echo "${PROGNAME:+$PROGNAME: }INFO: Installing atomic..." 1>&2


echo "${PROGNAME:+$PROGNAME: }INFO: Cloning openshift-ansible..." 1>&2
cd ~
if [ ! -d openshift-ansible ] ; then
  git clone https://github.com/openshift/openshift-ansible
fi
cd openshift-ansible
git pull

# #############################################################################
# Prep Docker

echo "${PROGNAME:+$PROGNAME: }INFO: Setting up Docker..." 1>&2
yum install docker-1.12.6
rpm -V docker-1.12.6
docker version

# #############################################################################
echo "${PROGNAME:+$PROGNAME: }INFO: Setting up Docker filesystem...." 1>&2
unset part
while [ ! -e "$part" ] ; then
  read -p "Enter partition (block device) for the Docker physical volume..." part
fi
pvcreate "$part"
vgcreate "$VG_NAME" "$part"

cat <<EOF > /etc/sysconfig/docker-storage-setup
VG=$VG_NAME
EOF

if systemctl is-active docker ; then
  systemctl stop docker
fi

docker-storage-setup
lvs

# #############################################################################
echo "${PROGNAME:+$PROGNAME: }INFO: Enabling and starting up Docker...." 1>&2
systemctl enable docker
systemctl start docker
