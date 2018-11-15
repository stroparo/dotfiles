#!/usr/bin/env bash

PROGNAME="setupjenkins-el.sh"

echo
echo "################################################################################"
echo "Setup Jenkins for EL Enterprise Linux based distributions"

# #############################################################################
# Checks

if ! egrep -i -q -r '(centos|fedora|oracle|red *hat).*7' /etc/*release ; then
  echo "${PROGNAME}: SKIP: Only Red Hat 7.x Linux distributions are supported." 1>&2
  exit
fi

# #############################################################################
# Requirements

"${RUNR_DIR:-$PWD}"/installers/setupepel.sh
sudo yum install -y wget

# #############################################################################
# Globals

USAGE="-s triggers the 'redhat-stable' setup otherwise use just the current 'redhat'"

# #############################################################################
# Options

STABLE_OPTION=false

# Options:
OPTIND=1
while getopts ':hs' option ; do
  case "${option}" in
    s) STABLE_OPTION=true;;
    h) echo "$USAGE"; exit;;
  esac
done
shift "$((OPTIND-1))"

# #############################################################################
# Install

if ! (java -version 2>/dev/null | egrep -i -q '(openjdk.*1[.]8|oracle)') ; then
  sudo yum -y remove java
  sudo yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-devel
fi

if ${STABLE_OPTION:-false} ; then
  sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo \
    && sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key \
    && sudo yum -y install jenkins-2.121.1
else
  sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins.io/redhat/jenkins.repo \
    && sudo rpm --import http://pkg.jenkins.io/redhat/jenkins.io.key \
    && sudo yum install -y jenkins
fi

sudo systemctl enable jenkins
sudo systemctl start jenkins

cat <<EOF
${PROGNAME}: # Run any of this command as applicable in your environment:
${PROGNAME}:
${PROGNAME}: # Enable the service:
${PROGNAME}: sudo systemctl enable jenkins
${PROGNAME}:
${PROGNAME}: # Start the service:
${PROGNAME}: sudo systemctl start jenkins
${PROGNAME}:
${PROGNAME}: # Firewall:
${PROGNAME}: sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent
${PROGNAME}: sudo firewall-cmd --zone=public --add-service=http --permanent
${PROGNAME}: sudo firewall-cmd --reload
${PROGNAME}:
${PROGNAME}: # URL:
${PROGNAME}: # http://localhost:8080
${PROGNAME}:
${PROGNAME}: # Check pass in log:
${PROGNAME}: sudo grep -A 5 password /var/log/jenkins/jenkins.log
EOF

# #############################################################################
# Finish

echo "${PROGNAME}: FINISHED Jenkins for EL Enterprise Linux distros setup"
echo
