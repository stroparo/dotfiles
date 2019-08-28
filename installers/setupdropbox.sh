#!/usr/bin/env bash

PROGNAME="setupdropbox.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi
if [ -e ~/.dropbox-dist/dropboxd ] ; then echo "PROGNAME: SKIP: Already installed" ; exit ; fi

echo "$PROGNAME: INFO: Dropbox setup started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

cd ~
wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" \
  | tar xzf -

env DBUS_SESSION_BUS_ADDRESS='' "${HOME}"/.dropbox-dist/dropboxd > /dev/null 2>&1 &

echo "$PROGNAME: COMPLETE: Dropbox setup"
exit
