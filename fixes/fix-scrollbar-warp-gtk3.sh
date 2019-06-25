#!/usr/bin/env bash

touch ~/.config/gtk-3.0/settings.ini
if ! grep -q warps-slider ~/.config/gtk-3.0/settings.ini ; then
  cat >> ~/.config/gtk-3.0/settings.ini <<EOF

[Settings]
gtk-primary-button-warps-slider = false
EOF
fi
