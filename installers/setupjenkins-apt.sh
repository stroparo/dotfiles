#!/usr/bin/env bash

PROGNAME="setupjenkins-apt.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi
if ! egrep -i -q -r 'debi|ubun' /etc/*release ; then ; echo "PROGNAME: SKIP: De/b/untu-like supported only" ; exit ; fi

echo "$PROGNAME: INFO: Jenkins for Debian distros setup started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Prep

if ! wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key \
  | sudo apt-key add -
then
  echo "${PROGNAME}: FATAL: Error adding key." 1>&2
  exit 1
fi

if ! sudo grep -i jenkins /etc/apt/sources.list ; then
  cat <<EOF | sudo tee -a /etc/apt/sources.list
deb https://pkg.jenkins.io/debian-stable binary/
EOF
  if [ "$?" -ne 0 ]; then
    echo "${PROGNAME}: FATAL: Error writing to sources.list" 1>&2
    exit 1
  fi
fi

# #############################################################################
# Main

echo "${PROGNAME}: INFO: Updating index..."
sudo apt update

echo "${PROGNAME}: INFO: Installing..."
sudo apt install -y jenkins

echo "${PROGNAME}: COMPLETE: Jenkins for Debian distros setup"
exit
