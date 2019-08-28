#!/usr/bin/env bash

PROGNAME="setupopenshift-el7.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi
if ! egrep -i -q -r 'red *hat.* 7' /etc/*release ; then echo "${PROGNAME}: SKIP: RHEL7 supported only" ; exit ; fi
if [ "$(id -u)" -ne 0 ]; then echo "${PROGNAME}: SKIP: Must be root" ; exit ; fi

echo "$PROGNAME: INFO: OpenShift for Enterprise Linux 7 setup started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Globals

set -e
PROGNAME=setupopenshift-el7.sh
VG_NAME=docker-vg

# #############################################################################
echo "${PROGNAME}: INFO: Installing dependencies..."

yum update -y
yum install -y wget git net-tools bind-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct
yum -y install \
    https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sed -i -e "s/^enabled=1/enabled=0/" /etc/yum.repos.d/epel.repo
yum -y --enablerepo=epel install ansible pyOpenSSL

# #############################################################################
echo "${PROGNAME}: INFO: Prep containerized installation..."

echo "${PROGNAME}: INFO: Installing atomic..."
# TODO

echo "${PROGNAME}: INFO: Cloning openshift-ansible..."
cd ~
if [ ! -d openshift-ansible ] ; then
  git clone --depth 1 https://github.com/openshift/openshift-ansible
fi
cd openshift-ansible
git pull

# #############################################################################
# Prep Docker

echo "${PROGNAME}: INFO: Setting up Docker..."
yum install docker-1.12.6
rpm -V docker-1.12.6
docker version

# #############################################################################
echo "${PROGNAME}: INFO: Setting up Docker filesystem...."

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
echo "${PROGNAME}: INFO: Enabling and starting up Docker...."

systemctl enable docker
systemctl start docker

# #############################################################################
# Final sequence

echo "$PROGNAME: COMPLETE: OpenShift for Enterprise Linux 7 setup"
exit
