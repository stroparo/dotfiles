#!/usr/bin/env bash

GTK3_SETTINGS_FILENAME="${HOME}/.config/gtk-3.0/settings.ini"

touch "${GTK3_SETTINGS_FILENAME}"

if ! grep -q 'gtk-primary-button-warps-slider' "${GTK3_SETTINGS_FILENAME}" ; then
  cat >> "${GTK3_SETTINGS_FILENAME}" <<EOF

[Settings]
gtk-primary-button-warps-slider = false
EOF
fi
