#!/usr/bin/env bash

PROGNAME="setupgcp-el.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi
if ! egrep -i -q -r 'cent *os|fedora|oracle|red *hat' /etc/*release ; then echo "${PROGNAME}: SKIP: EL supported only" 1>&2 ; exit ; fi

echo "$PROGNAME: INFO: GCP - Google Cloud Platform - SDK - google-cloud-sdk setup started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Globals

export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf

# #############################################################################
# Main

# Update YUM with Cloud SDK repo information:
sudo tee -a /etc/yum.repos.d/google-cloud-sdk.repo <<EOM
[google-cloud-sdk]
name=Google Cloud SDK
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOM

# The indentation for the 2nd line of gpgkey is important.

# Install the Cloud SDK
sudo $RPMPROG install google-cloud-sdk

echo "$PROGNAME: COMPLETE: GCP SDK setup"
exit
