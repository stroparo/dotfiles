#!/usr/bin/env bash

PROGNAME="setupdocker.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi
if type docker >/dev/null 2>&1 ; then echo "$PROGNAME: SKIP: Already installed" 1>&2 ; exit ; fi

echo "$PROGNAME: INFO: Docker container platform setup started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

echo
sh -c "$(curl -fsSL https://get.docker.com)"

echo
sudo usermod -aG docker "$USER"

echo
sudo docker run hello-world

echo
echo "$PROGNAME: COMPLETE: Docker setup"
