#!/bin/bash

sudo tee -a /etc/sysctl.d/50-coredump.conf >/dev/null <<EOF
kernel.core_pattern=|/bin/false
EOF

sudo sysctl -p /etc/sysctl.d/50-coredump.conf
