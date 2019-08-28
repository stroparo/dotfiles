#!/bin/bash

PROGNAME="fix-dropbox-start.sh"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

if [ ! -e "${HOME}/.dropbox-dist/dropboxd" ] ; then
  exit
fi

# Desktop tray workaround (export empty DBUS_SESSION_BUS_ADDRESS for process).
# This approach doesnt work as Dropbox often updates itself:
# sed -i -e 's/^exec.*dropbox/export DBUS_SESSION_BUS_ADDRESS=""; &/' ~/.dropbox-dist/dropboxd
# This is a better one, doing that for its autostart spec:
cat > ~/.config/autostart/dropbox.desktop <<EOF
[Desktop Entry]
Encoding=UTF-8
Version=0.9.4
Type=Application
Name=dropbox
Comment=dropbox
Exec=env DBUS_SESSION_BUS_ADDRESS='' ${HOME}/.dropbox-dist/dropboxd
OnlyShowIn=XFCE;
StartupNotify=false
Terminal=false
Hidden=false
EOF

