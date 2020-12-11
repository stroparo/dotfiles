#!/usr/bin/env bash

PROGNAME="setupmongodb.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi
if ! grep -i -q ubuntu /etc/*release ; then echo "$PROGNAME: SKIP: Ubuntu supported only" ; exit ; fi

echo "$PROGNAME: INFO: MongoDB setup started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

if ! which mongod >/dev/null 2>&1 ; then
  sudo apt-get update
  sudo apt-get install gnupg
  wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
  echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
  sudo apt-get update
  sudo apt-get install -y mongodb-org
fi
sudo su -c 'echo "mongodb previous ulimit:"; ulimit -n; ulimit -n 64000; echo "ulimit open files set to:"; ulimit -n' -

echo
echo "$PROGNAME: COMPLETE: MongoDB setup"

echo
echo

exit
