#!/usr/bin/env bash

PROGNAME="fix-apt-modes.sh"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# Fix workaround for /etc/apt/sources.list.d mode issue.
#  This will sudo chmod 644 all files in /etc/apt/sources.list.d
# Rmk: Common scenario this glitch happens is a call
#  to update after adding a ppa repo.

if [ -d /etc/apt/sources.list.d ] ; then
  sudo chmod 644 /etc/apt/sources.list.d/*
fi
