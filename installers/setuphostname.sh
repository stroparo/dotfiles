#!/usr/bin/env bash

PROGNAME="setuphostname.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi

echo "$PROGNAME: INFO: hostname setup started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

echo ${BASH_VERSION:+-e} "\nHostname: \c" ; read newhostname
sudo hostnamectl set-hostname "${newhostname:-andromeda}"

echo "$PROGNAME: COMPLETE: hostname setup"
exit
