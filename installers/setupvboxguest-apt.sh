#!/usr/bin/env bash

PROGNAME="setupvboxguest-apt.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi
if ! egrep -i -q -r 'debi|ubun' /etc/*release ; then ; echo "PROGNAME: SKIP: De/b/untu-like supported only" ; exit ; fi

echo "$PROGNAME: INFO: VirtualBox guest for Debian distros setup started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

sudo apt update
sudo apt install -y build-essential dkms module-assistant

echo "$PROGNAME: COMPLETE: VirtualBox guest additions setup"
exit
