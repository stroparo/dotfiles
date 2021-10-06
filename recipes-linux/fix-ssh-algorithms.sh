#!/usr/bin/env bash

PROGNAME="fix-ssh-algorithms.sh"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"


if ! fgrep -q 'HostKeyAlgorithms +ssh-rsa' /etc/ssh/ssh_config ; then
  echo 'HostKeyAlgorithms +ssh-rsa' | sudo tee -a /etc/ssh/ssh_config > /dev/null
fi
