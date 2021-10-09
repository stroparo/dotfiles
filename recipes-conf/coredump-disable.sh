#!/bin/bash

if ! sudo fgrep 'kernel.core_pattern=|/bin/false' /etc/sysctl.d/50-coredump.conf ; then
  sudo tee -a /etc/sysctl.d/50-coredump.conf >/dev/null <<EOF
kernel.core_pattern=|/bin/false
EOF
  sudo sysctl -p /etc/sysctl.d/50-coredump.conf
fi
