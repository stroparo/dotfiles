#!/usr/bin/env bash

PROGNAME="setupdocker.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi
if type docker >/dev/null 2>&1 ; then echo "$PROGNAME: SKIP: Already installed" 1>&2 ; exit ; fi

# LINUX_RELEASE global:
LINUX_RELEASE="$(grep 'UBUNTU_CODENAME=' /etc/os-release | cut -d'=' -f2)"
: ${LINUX_RELEASE:=$(lsb_release -cs)}
export LINUX_RELEASE

echo "$PROGNAME: INFO: Docker container platform setup started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

if egrep -i -q 'id[^=]*=arch' /etc/*release ; then

  sudo pacman -Sy docker

elif grep -i -q ubuntu /etc/*release ; then

  sudo apt-get update

  sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

  echo "$PROGNAME: INFO: Searching for fingerprint '...0EBFCD88' ..."
  sudo apt-key fingerprint "0EBFCD88"

  sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
 ${LINUX_RELEASE} \
 stable"

  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io
else
  echo
  sh -c "$(curl -fsSL https://get.docker.com)"
fi

echo
echo Executing sudo usermod -aG docker "$USER" ...
sudo usermod -aG docker "$USER"

echo
sudo docker run hello-world

echo
echo "$PROGNAME: COMPLETE: Docker setup"

echo
echo

exit
