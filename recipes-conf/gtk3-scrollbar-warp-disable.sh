#!/usr/bin/env bash

PROGNAME="fix-scrollbar-warp-gtk3.sh"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

GTK3_SETTINGS_FILENAME="${HOME}/.config/gtk-3.0/settings.ini"

if [ ! -e "$(dirname "${GTK3_SETTINGS_FILENAME}")" ] ; then
  mkdir -p "$(dirname "${GTK3_SETTINGS_FILENAME}")"
fi
if [ ! -e "$(dirname "${GTK3_SETTINGS_FILENAME}")" ] ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: Dir '"$(dirname "${GTK3_SETTINGS_FILENAME}")"' must be available." 1>&2
  exit 1
fi

touch "${GTK3_SETTINGS_FILENAME}"

if ! grep -q 'gtk-primary-button-warps-slider' "${GTK3_SETTINGS_FILENAME}" ; then
  cat >> "${GTK3_SETTINGS_FILENAME}" <<EOF

[Settings]
gtk-primary-button-warps-slider = false
EOF
fi
