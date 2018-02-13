#!/usr/bin/env bash

# Daily Shells Extras extensions
# More instructions and licensing at:
# https://github.com/stroparo/ds-extras

echo ${BASH_VERSION:+-e} '\n\n==> Installing jenkins (RHEL)...' 1>&2

# #############################################################################
# Checks

if ! egrep -i -q 'centos|fedora|oracle|red *hat' /etc/*release* ; then
  echo "FATAL: Only Red Hat distros supported." 1>&2
  exit 1
fi

# #############################################################################
# Install

sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins.io/redhat/jenkins.repo \
  && sudo rpm --import http://pkg.jenkins.io/redhat/jenkins.io.key \
  && sudo yum install -y jenkins

cat <<EOF
# Run any of this command as applicable in your environment:

# Start the service:
sudo systemctl start jenkins

# Enable the service:
sudo systemctl enable jenkins

# Firewall:
sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent
sudo firewall-cmd --zone=public --add-service=http --permanent
sudo firewall-cmd --reload

# URL:
# http://localhost:8080

# Check pass in log:
sudo grep -A 5 password /var/log/jenkins/jenkins.log
EOF

# #############################################################################